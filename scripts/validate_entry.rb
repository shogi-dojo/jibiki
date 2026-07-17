#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../lib/dictionary_sources/jmdict'

REPO_ROOT = File.expand_path('..', __dir__)
JMDICT_PATH = ENV.fetch(
  'JMDICT_PATH',
  File.join(REPO_ROOT, 'sources', 'jmdict', 'JMdict.xml.gz')
)

STABLE_ID_PATTERN = /(?:\A|\s)(?<id>(?:(?:wf|rd|s|ru-ref)-\d+-\d{3}|(?:en-s|uk-s|note-s|col-s|con-s|rel-s|idiom-s|ex|accent-rd|audio-rd)-\d+-\d{3}-\d{3}))\z/

# Reading the gzipped archive dominates runtime, so keep one reader and one
# cache per process: validating N entries must not mean N full archive scans.
def jmdict
  @jmdict ||= DictionarySources::Jmdict.new(JMDICT_PATH)
end

def jmdict_entry(ent_seq)
  @jmdict_entries ||= {}
  @jmdict_entries.fetch(ent_seq) do
    @jmdict_entries[ent_seq] = jmdict.lookup(ent_seq:).first
  end
end

# Prime the cache for many entries in a single archive pass.
def preload_jmdict_entries(ent_seqs)
  ent_seqs = ent_seqs.compact.uniq
  return if ent_seqs.length < 2

  @jmdict_entries ||= {}
  queries = ent_seqs.map { |seq| { ent_seq: seq } }
  jmdict.lookup_many(queries).each_with_index do |matches, index|
    @jmdict_entries[ent_seqs[index]] = matches.first
  end
end

def validate_entry(filepath)
  puts "Validating Org entry: #{filepath}"
  errors = []

  unless File.exist?(filepath)
    errors << "File does not exist: #{filepath}"
    return errors
  end

  # Read file bytes
  content_bytes = File.binread(filepath)

  # Check UTF-8 validity
  begin
    content = content_bytes.force_encoding('UTF-8')
    unless content.valid_encoding?
      errors << "File content is not valid UTF-8"
    end
  rescue => e
    errors << "Failed to decode UTF-8: #{e.message}"
    return errors
  end

  # Check NFC normalization
  unless content.unicode_normalized?(:nfc)
    errors << "File content is not normalized to Unicode NFC"
  end

  # Check CRLF (carriage return)
  if content_bytes.include?("\r")
    errors << "File contains CRLF line endings or carriage returns"
  end

  # Check Tabs
  if content_bytes.include?("\t")
    errors << "File contains tabs"
  end

  # Check trailing whitespace
  lines = content.split("\n", -1)
  lines.each_with_index do |line, idx|
    line_num = idx + 1
    if line.end_with?(' ') || line.end_with?("\t")
      errors << "Line #{line_num} has trailing whitespace"
    end

    if line.match?(/^- (?:JA|READING) :: .*\p{Cyrillic}/)
      errors << "Line #{line_num} contains Cyrillic text in a Japanese field"
    end
  end

  # Check file-level keywords
  required_keywords = [
    /^#\+TITLE: (.*)$/,
    /^#\+JMDICT_ID: (.*)$/,
    /^#\+SCHEMA_VERSION: 1$/,
    /^#\+PRIMARY_READING: (.*)$/,
    /^#\+ROMAJI: (.*)$/,
    /^#\+ENTRY_STATUS: (untranslated|draft|reviewed)$/,
    /^#\+QUALITY_PROFILE: (core|learner|enriched|gold)$/,
    /^#\+JMDICT_SOURCE_SHA256: ([0-9a-f]{64})$/
  ]

  kw_index = 0
  headers = {}
  lines.take(12).each_with_index do |line, idx|
    line_num = idx + 1
    if line.start_with?('#+')
      if kw_index < required_keywords.length
        pattern = required_keywords[kw_index]
        if line =~ pattern
          headers[pattern] = $1 || true
        else
          errors << "Header line #{line_num} does not match expected pattern #{pattern.inspect}: #{line.inspect}"
        end
        kw_index += 1
      elsif line =~ /^#\+CREATED_AT:\s*(.*)$/
        headers[:created_at] = $1
      end
    end
  end

  if kw_index < required_keywords.length
    errors << "Missing required file-level headers at the beginning of the file"
  end

  ent_seq = headers[required_keywords[1]]
  romaji = headers[required_keywords[4]]
  entry_status = headers[required_keywords[5]]
  quality_profile = headers[required_keywords[6]]

  if quality_profile == 'gold' && entry_status != 'reviewed'
    errors << 'QUALITY_PROFILE gold requires ENTRY_STATUS reviewed'
  end

  if quality_profile == 'gold'
    lines.each_with_index do |line, idx|
      next unless line.match?(/^\*{3}\s+uk-s-/)

      drawer_end = lines[(idx + 1)..].index { |candidate| candidate == ':END:' }
      unless drawer_end
        errors << "Ukrainian gloss at line #{idx + 1} has no complete property drawer"
        next
      end

      drawer = lines[(idx + 1)..(idx + 1 + drawer_end)]
      status = drawer.filter_map { |candidate| candidate[/^:STATUS:\s*(\S+)$/, 1] }.first
      errors << "Gold entry has unreviewed Ukrainian gloss at line #{idx + 1}" unless status == 'reviewed'
    end
  end

  # Check path agreement
  if ent_seq
    expected_dir = (ent_seq.to_i / 1000).to_s
    expected_filename = "#{ent_seq}-#{romaji}.org"
    actual_dir = File.basename(File.dirname(filepath))
    actual_filename = File.basename(filepath)

    if actual_dir != expected_dir
      errors << "Directory name mismatch: expected #{expected_dir}, got #{actual_dir}"
    end
    if actual_filename != expected_filename
      errors << "Filename mismatch: expected #{expected_filename}, got #{actual_filename}"
    end
  end

  # Check stable IDs uniqueness and format
  ids = {}
  lines.each_with_index do |line, idx|
    line_num = idx + 1
    if line =~ /^(\*+)\s+(.*)$/
      stars, heading_title = $1, $2
      if (match = heading_title.match(STABLE_ID_PATTERN))
        node_id = match[:id]
        if ids.key?(node_id)
          errors << "Duplicate stable ID '#{node_id}' at lines #{ids[node_id]} and #{line_num}"
        else
          ids[node_id] = line_num
        end
      end
    end
  end

  # Check sense fingerprints
  senses = {}
  lines.each_with_index do |line, idx|
    if line =~ /^\*\s+Sense\s+(s-\d+-\d+)/
      current_sense = $1
      senses[current_sense] = {}
      if lines[idx + 1]&.strip == ':PROPERTIES:'
        offset = 2
        while lines[idx + offset] && lines[idx + offset].strip != ':END:'
          prop_line = lines[idx + offset].strip
          if prop_line =~ /^:([^:]+):\s*(.*)$/
            senses[current_sense][$1] = $2
          end
          offset += 1
        end
      end
    end
  end

  if senses.empty?
    errors << "No Sense headings found in file"
  else
    puts "Looking up entry #{ent_seq} in JMdict..."
    source_entry = jmdict_entry(ent_seq)

    if source_entry.nil?
      errors << "JMdict entry #{ent_seq} not found in #{JMDICT_PATH}"
    else
      senses.each do |s_id, props|
        source_sense_index = props['SOURCE_SENSE_INDEX']&.to_i

        if source_sense_index.nil?
          errors << "Missing SOURCE_SENSE_INDEX property under sense #{s_id}"
          next
        end

        source_sense = source_entry[:senses][source_sense_index - 1]
        if source_sense.nil?
          errors << "No XML sense at index #{source_sense_index} in JMdict entry"
          next
        end

        expected_fp = source_sense[:source_fingerprint]
        actual_fp = props['SOURCE_FINGERPRINT']

        if actual_fp != expected_fp
          errors << "Fingerprint mismatch for #{s_id}: expected #{expected_fp}, got #{actual_fp}"
        end
      end
    end
  end

  errors
end

if __FILE__ == $PROGRAM_NAME
  if ARGV.empty?
    puts "Usage: ruby validate_entry.rb <path_to_org_file> [<path_to_org_file> ...]"
    exit 1
  end

  preload_jmdict_entries(ARGV.filter_map do |path|
    next unless File.exist?(path)

    File.binread(path).force_encoding('UTF-8')[/^#\+JMDICT_ID: (.*)$/, 1]
  end)

  failed = false
  ARGV.each do |path|
    errors = validate_entry(path)
    if errors.empty?
      puts "Validation PASSED successfully!"
    else
      puts "Validation FAILED with #{errors.length} errors:"
      errors.each { |err| puts "- #{err}" }
      failed = true
    end
  end

  exit(failed ? 2 : 0)
end
