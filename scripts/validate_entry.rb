#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../lib/dictionary_sources/jmdict'

REPO_ROOT = File.expand_path('..', __dir__)
JMDICT_PATH = ENV.fetch(
  'JMDICT_PATH',
  File.join(REPO_ROOT, 'sources', 'jmdict', 'JMdict.xml.gz')
)

STABLE_ID_PATTERN = /(?:\A|\s)(?<id>(?:(?:wf|rd|s|ru-ref)-\d+-\d{3}|(?:en-s|uk-s|note-s|col-s|con-s|rel-s|idiom-s|ex|accent-rd|audio-rd)-\d+-\d{3}-\d{3}))\z/

# Exact field values the batch generator emitted as placeholders. Matched whole,
# never as substrings. 'Basic word.' is the learner-note stub; the rest are the
# example stub.
PLACEHOLDER_FIELDS = {
  'JA' => ['例'],
  'READING' => ['れい'],
  'UK' => ['Приклад.', 'Basic word.'],
  'EN' => ['Example.'],
  'FOCUS' => ['例']
}.freeze

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

    # The batch generator stamped a literal 例/Приклад./Basic word. template into
    # every entry it produced. Those pass every structural check while carrying
    # no content, so reject them by exact match: a real sentence may legitimately
    # contain 例 (例えば, 例文), but never as the entire field.
    PLACEHOLDER_FIELDS.each do |field, values|
      value = values.find { |candidate| line == "- #{field} :: #{candidate}" }
      next unless value

      errors << "Line #{line_num} is an unedited #{field} placeholder: #{value}"
    end
  end

  # Check file-level keywords
  required_keywords = [
    /^#\+TITLE: (.*)$/,
    /^#\+JMDICT_ID: (.*)$/,
    /^#\+SCHEMA_VERSION: 2$/,
    /^#\+PRIMARY_READING: (.*)$/,
    /^#\+ROMAJI: (.*)$/,
    /^#\+ENTRY_STATUS: (untranslated|draft|reviewed)$/,
    /^#\+QUALITY_PROFILE: (core|learner|enriched|gold)$/,
    /^#\+JMDICT_SOURCE_SHA256: ([0-9a-f]{64})$/
  ]

  kw_index = 0
  headers = {}
  file_defaults = {}
  lines.take(16).each_with_index do |line, idx|
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
      elsif line =~ /^#\+DEFAULT_(AUTHOR_ID|LICENSE|SOURCE_TYPE|STATUS):\s?(.*)$/
        file_defaults[$1] = $2
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
      status = drawer.filter_map { |candidate| candidate[/^:STATUS:\s*(\S+)$/, 1] }.first || file_defaults['STATUS']
      errors << "Gold entry has unreviewed Ukrainian gloss at line #{idx + 1}" unless status == 'reviewed'
    end
  end

  # Schema v2 omit-when-empty (docs/org-format.md §15): a listed subsection
  # heading is only ever allowed to appear when it has content: leaving it
  # empty is a v1 pattern the migration removed everywhere.
  omit_when_empty_headings = [
    'Information', 'Priorities', 'Fields', 'Miscellaneous and register',
    'Dialects', 'Sense information', 'Cross-references', 'Antonyms',
    'Language sources', 'Russian reference', 'Learner notes', 'Collocations',
    'Constructions and derivatives', 'Related words', 'Idioms and proverbs',
    'Examples'
  ].freeze

  lines.each_with_index do |line, idx|
    next unless line =~ /^(\*+)\s+(.*)$/

    stars, heading_title = $1, $2
    next unless omit_when_empty_headings.include?(heading_title)

    level = stars.length
    body = []
    offset = idx + 1
    while lines[offset] && !(lines[offset] =~ /^(\*+)\s+/ && $1.length <= level)
      body << lines[offset]
      offset += 1
    end

    has_content = body.any? { |l| l.start_with?('- ') } || body.any? { |l| l =~ /^\*{#{level + 1},}\s+/ }
    errors << "Line #{idx + 1} '#{heading_title}' is empty and must be omitted (schema v2 §15)" unless has_content
  end

  # Schema v2 provenance defaults (§5/§9): a block's drawer must omit any
  # property whose value equals the file's matching #+DEFAULT_* keyword.
  defaultable_provenance_keys = %w[SOURCE_TYPE AUTHOR_ID LICENSE STATUS].freeze
  lines.each_with_index do |line, idx|
    next unless line =~ /^\*+\s+(?:uk-s-|note-s-|col-s-|con-s-|rel-s-|idiom-s-|ex-)/

    drawer_end = lines[(idx + 1)..]&.index { |candidate| candidate.strip == ':END:' }
    next unless drawer_end && lines[idx + 1]&.strip == ':PROPERTIES:'

    drawer = lines[(idx + 2)..(idx + drawer_end)]
    drawer.each_with_index do |prop_line, offset|
      next unless prop_line =~ /^:([^:]+):\s?(.*)$/

      key = $1
      value = $2
      next unless defaultable_provenance_keys.include?(key) && file_defaults[key] && value == file_defaults[key]

      errors << "Line #{idx + 2 + offset} property #{key} redundantly repeats the file default and must be omitted (schema v2 §9)"
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
  sense_starts = []
  lines.each_with_index do |line, idx|
    if line =~ /^\*\s+Sense\s+(s-\d+-\d+)/
      current_sense = $1
      senses[current_sense] = {}
      sense_starts << [current_sense, idx]
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

  # Schema v2 LEARNER_PRIORITY example requirement (§10/§18): a sense marked
  # primary needs at least 3 examples with a graded LEVEL mix, replacing the
  # old informal "3 examples per common word" guidance with a structural gate.
  sense_starts.each_with_index do |(s_id, start_idx), sense_index|
    next unless senses[s_id]['LEARNER_PRIORITY'] == 'primary'

    end_idx = sense_starts[sense_index + 1]&.last || lines.length
    sense_lines = lines[start_idx...end_idx]

    levels = []
    sense_lines.each_with_index do |line, offset|
      next unless line =~ /^\*+\s+ex-/

      drawer_end = sense_lines[(offset + 1)..]&.index { |candidate| candidate.strip == ':END:' }
      level =
        if drawer_end && sense_lines[offset + 1]&.strip == ':PROPERTIES:'
          sense_lines[(offset + 2)..(offset + 1 + drawer_end)].filter_map { |l| l[/^:LEVEL:\s*(\S+)$/, 1] }.first
        end
      levels << (level || 'beginner')
    end

    if levels.length < 3
      errors << "Sense #{s_id} is LEARNER_PRIORITY primary but has only #{levels.length} example(s); at least 3 are required"
    elsif !levels.include?('beginner') || !(levels.include?('intermediate') || levels.include?('neutral'))
      errors << "Sense #{s_id} is LEARNER_PRIORITY primary but its examples are not graded (need at least one beginner and one neutral/intermediate LEVEL); got #{levels.inspect}"
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
