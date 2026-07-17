#!/usr/bin/env ruby
# frozen_string_literal: true

require 'zlib'
require 'rexml/document'
require 'json'
require 'digest'

JMDICT_PATH = '/Users/mac/projects/jisho/sources/jmdict/JMdict.xml.gz'

def parse_entities(jmdict_path)
  entities = {}
  Zlib::GzipReader.open(jmdict_path) do |gz|
    gz.each_line.with_index do |line, idx|
      break if idx > 2000
      if line =~ /<!ENTITY\s+(\S+)\s+"([^"]+)"\s*>/
        entities[$2] = $1
      end
    end
  end
  entities
end

def find_entry_xml(jmdict_path, ent_seq)
  inside_entry = false
  current_entry_lines = []
  
  Zlib::GzipReader.open(jmdict_path) do |gz|
    gz.each_line do |line|
      if line.include?('<entry>')
        inside_entry = true
        current_entry_lines = [line]
      elsif inside_entry
        current_entry_lines << line
        if line.include?('</entry>')
          inside_entry = false
          joined = current_entry_lines.join
          if joined.include?("<ent_seq>#{ent_seq}</ent_seq>")
            return joined
          end
        end
      end
    end
  end
  nil
end

def extract_element_texts(sense_el, tag, entities_map = nil)
  elements = sense_el.get_elements(tag)
  return [] if elements.empty?
  
  elements.map do |el|
    text = el.text || ''
    if text =~ /^&(\S+);$/
      $1
    elsif entities_map
      entities_map[text] || text
    else
      text
    end
  end
end

def compute_sense_fingerprint(ent_seq, sense_index, sense_el, entities_map)
  # Fields: ent_seq, sense_index, stagk, stagr, pos, xref, ant, field, misc, s_inf, lsource, dial, gloss, example
  
  stagk = extract_element_texts(sense_el, 'stagk')
  stagr = extract_element_texts(sense_el, 'stagr')
  pos = extract_element_texts(sense_el, 'pos', entities_map)
  xref = extract_element_texts(sense_el, 'xref')
  ant = extract_element_texts(sense_el, 'ant')
  field = extract_element_texts(sense_el, 'field', entities_map)
  misc = extract_element_texts(sense_el, 'misc', entities_map)
  s_inf = extract_element_texts(sense_el, 's_inf')
  dial = extract_element_texts(sense_el, 'dial', entities_map)
  
  # lsource
  lsource = sense_el.get_elements('lsource').map do |el|
    {
      'lang' => el.attribute('lang', 'xml')&.value || 'eng',
      'type' => el.attribute('ls_type')&.value || 'full',
      'wasei' => el.attribute('ls_wasei')&.value == 'y',
      'text' => el.text || ''
    }
  end
  
  # gloss
  gloss = sense_el.get_elements('gloss').map do |el|
    {
      'lang' => el.attribute('lang', 'xml')&.value || 'eng',
      'type' => el.attribute('g_type')&.value || 'plain',
      'gender' => el.attribute('g_gend')&.value || 'none',
      'primary' => false, # Default false
      'text' => el.text || ''
    }
  end
  
  # example
  example = sense_el.get_elements('example').map do |el|
    # Default placeholder structure if examples exist in JMdict
    {
      'db' => el.attribute('db')&.value || '',
      'id' => el.attribute('id')&.value || '',
      'text' => el.text || ''
    }
  end

  data = {
    'ent_seq' => ent_seq.to_s,
    'sense_index' => sense_index.to_i,
    'stagk' => stagk,
    'stagr' => stagr,
    'pos' => pos,
    'xref' => xref,
    'ant' => ant,
    'field' => field,
    'misc' => misc,
    's_inf' => s_inf,
    'lsource' => lsource,
    'dial' => dial,
    'gloss' => gloss,
    'example' => example
  }

  json_str = JSON.generate(data)
  Digest::SHA256.hexdigest(json_str)
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
  end

  # Check file-level keywords
  required_keywords = [
    /^#\+TITLE: (.*)$/,
    /^#\+JMDICT_ID: (.*)$/,
    /^#\+SCHEMA_VERSION: 1$/,
    /^#\+PRIMARY_READING: (.*)$/,
    /^#\+ROMAJI: (.*)$/,
    /^#\+ENTRY_STATUS: (.*)$/,
    /^#\+QUALITY_PROFILE: (.*)$/,
    /^#\+JMDICT_SOURCE_SHA256: (.*)$/
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
      # Search for ID pattern
      if heading_title =~ /\b(wf|rd|s|en-s|uk-s|ru-ref|note-s|ex)-\d+-\d+(?:-\d+)?\b/
        node_id = $&
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
    puts "Parsing DTD and looking up entry #{ent_seq} in JMdict..."
    entities_map = parse_entities(JMDICT_PATH)
    entry_xml = find_entry_xml(JMDICT_PATH, ent_seq)
    
    if entry_xml.nil?
      errors << "JMdict entry #{ent_seq} not found in #{JMDICT_PATH}"
    else
      doc = REXML::Document.new(entry_xml)
      all_xml_senses = doc.get_elements('//sense')
      
      # We need to map English senses in the XML to the Org file senses
      english_senses_xml = all_xml_senses.select do |s|
        !s.get_elements("gloss[@xml:lang='eng']").empty? || s.get_elements("gloss").all? { |g| g.attribute('lang', 'xml')&.value == 'eng' || g.attribute('lang', 'xml').nil? }
      end
      
      senses.each_with_index do |(s_id, props), idx|
        sense_index = idx + 1
        source_sense_index = props['SOURCE_SENSE_INDEX']&.to_i
        
        if source_sense_index.nil?
          errors << "Missing SOURCE_SENSE_INDEX property under sense #{s_id}"
          next
        end

        xml_sense_el = all_xml_senses[source_sense_index - 1]
        if xml_sense_el.nil?
          errors << "No XML sense at index #{source_sense_index} in JMdict entry"
          next
        end

        expected_fp = compute_sense_fingerprint(ent_seq, sense_index, xml_sense_el, entities_map)
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
    puts "Usage: ruby validate_entry.rb <path_to_org_file>"
    exit 1
  end

  errors = validate_entry(ARGV[0])
  if errors.empty?
    puts "Validation PASSED successfully!"
    exit 0
  else
    puts "Validation FAILED with #{errors.length} errors:"
    errors.each { |err| puts "- #{err}" }
    exit 2
  end
end
