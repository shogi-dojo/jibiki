#!/usr/bin/env ruby
# frozen_string_literal: true

# Mechanically migrates schema version 1 Org entries to schema version 2:
# omit-when-empty list subsections, file-level provenance defaults, compact
# English-gloss/Russian-reference syntax, and a LEARNER_PRIORITY sense
# property. No JMdict re-derivation happens here; fingerprints already pin
# source state. See docs/org-format.md for the schema 2 rules this encodes.

ENRICHMENT_ID_PATTERN = /^(uk-s-|note-s-|col-s-|con-s-|rel-s-|idiom-s-|ex-)/.freeze

OMIT_WHEN_EMPTY_HEADINGS = [
  'Information',
  'Priorities',
  'Fields',
  'Miscellaneous and register',
  'Dialects',
  'Sense information',
  'Cross-references',
  'Antonyms',
  'Language sources',
  'Russian reference',
  'Learner notes',
  'Collocations',
  'Constructions and derivatives',
  'Related words',
  'Idioms and proverbs',
  'Examples'
].freeze

FILE_LEVEL_PROVENANCE_DEFAULTS = {
  'SOURCE_TYPE' => 'original',
  'AUTHOR_ID' => 'antigravity',
  'LICENSE' => 'CC-BY-SA-4.0',
  'STATUS' => 'draft'
}.freeze

Node = Struct.new(:level, :title, :lines, :children) do
  def heading_name
    title.sub(/\s+[\w-]+-[\w-]+\z/, '').strip
  end
end

# Parses the flat line list under one heading into a tree of Nodes, each
# holding its own non-heading lines (properties drawer, list items) plus
# nested child headings. `level` 0 is the synthetic file root.
def parse_tree(lines)
  root = Node.new(0, nil, [], [])
  stack = [root]

  lines.each do |line|
    if line =~ /^(\*+)\s+(.*)$/
      level = Regexp.last_match(1).length
      title = Regexp.last_match(2)
      node = Node.new(level, title, [], [])
      stack.pop while stack.last.level >= level
      stack.last.children << node
      stack.push(node)
    else
      stack.last.lines << line
    end
  end

  root
end

def drawer_properties(lines)
  return [nil, nil, {}] unless lines.first&.strip == ':PROPERTIES:'

  end_index = lines.index { |l| l.strip == ':END:' }
  raise "Unterminated :PROPERTIES: drawer" unless end_index

  props = {}
  order = []
  lines[1...end_index].each do |line|
    next unless line =~ /^:([^:]+):\s?(.*)$/

    key = Regexp.last_match(1)
    value = Regexp.last_match(2)
    props[key] = value
    order << key
  end

  [0, end_index, props]
end

def rebuild_drawer(order, props)
  body = order.map { |key| ":#{key}: #{props[key]}".rstrip }
  [':PROPERTIES:', *body, ':END:']
end

# Applies file-level provenance defaults (§5/§9): drops a provenance property
# from a block's drawer when it equals the matching file default.
def compact_provenance_drawer(lines, defaults)
  start_index, end_index, props = drawer_properties(lines)
  return lines unless start_index

  order = lines[1...end_index].filter_map { |l| l[/^:([^:]+):/, 1] }

  kept_order = order.reject do |key|
    default_value =
      case key
      when 'CREATED_AT' then defaults[:created_at]
      else defaults[:provenance][key]
      end
    !default_value.nil? && props[key] == default_value
  end

  new_drawer = rebuild_drawer(kept_order, props)
  new_drawer + lines[(end_index + 1)..]
end

# Rewrites a `** English glosses` node's `en-...` children into compact plain
# list items when TYPE/GENDER/LANG are all default, keeping the heading form
# otherwise. Returns the flat line array for the whole subsection body.
def compact_english_glosses(node)
  out = []
  node.children.each do |child|
    _, end_index, props = drawer_properties(child.lines)
    text_line = child.lines[(end_index + 1)..].find { |l| l.start_with?('- text :: ') }
    text = text_line.sub('- text :: ', '')

    default_attrs = props['LANG'] == 'eng' && props['TYPE'] == 'plain' && props['GENDER'] == 'none'

    if default_attrs
      out << "- #{text}"
    else
      out << "*** #{child.title}"
      out.concat(child.lines)
    end
  end
  out
end

# Rewrites a `** Russian reference` node's `ru-ref-...` children into compact
# `<index> :: <text>` list items when the drawer carries only
# SOURCE_SENSE_INDEX, keeping the heading form otherwise.
def compact_russian_reference(node)
  out = []
  node.children.each do |child|
    _, end_index, props = drawer_properties(child.lines)
    text_line = child.lines[(end_index + 1)..].find { |l| l.start_with?('- text :: ') }
    text = text_line.sub('- text :: ', '')

    if props.keys == ['SOURCE_SENSE_INDEX']
      out << "- #{props['SOURCE_SENSE_INDEX']} :: #{text}"
    else
      out << "*** #{child.title}"
      out.concat(child.lines)
    end
  end
  out
end

def list_items_present?(lines)
  lines.any? { |l| l.start_with?('- ') }
end

def wildcard_only_forms_restriction?(applies_node)
  written = applies_node.children.find { |c| c.heading_name == 'Written forms' }
  readings = applies_node.children.find { |c| c.heading_name == 'Readings' }
  return false unless written && readings

  written.lines == ['- *'] && readings.lines == ['- *']
end

# Emits one heading (with its own lines and, recursively, its children) as
# flat Org lines, applying the omit-when-empty and compaction rules.
def render_node(node, defaults, learner_priority_sense_ids)
  out = []
  stars = '*' * node.level
  heading_name = node.heading_name

  if node.title&.match?(/\ASense s-\d+-\d+\z/)
    out << "#{stars} #{node.title}"
    lines = node.lines.dup
    if learner_priority_sense_ids.include?(node.title[/\As-\d+-\d+\z|s-\d+-\d+/])
      start_index, end_index, props = drawer_properties(lines)
      if start_index
        order = lines[1...end_index].filter_map { |l| l[/^:([^:]+):/, 1] }
        order << 'LEARNER_PRIORITY' unless order.include?('LEARNER_PRIORITY')
        props['LEARNER_PRIORITY'] = 'primary'
        lines = rebuild_drawer(order, props) + lines[(end_index + 1)..]
      end
    end
    out.concat(lines)
    node.children.each { |child| out.concat(render_node(child, defaults, learner_priority_sense_ids)) }
    return out
  end

  if heading_name == 'Applies to forms' && wildcard_only_forms_restriction?(node)
    return []
  end

  if OMIT_WHEN_EMPTY_HEADINGS.include?(heading_name)
    has_content = list_items_present?(node.lines) || node.children.any?
    return [] unless has_content
  end

  out << "#{stars} #{node.title}"

  if heading_name == 'English glosses' && node.children.any?
    out.concat(compact_english_glosses(node))
    return out
  end

  if heading_name == 'Russian reference' && node.children.any?
    out.concat(compact_russian_reference(node))
    return out
  end

  lines = node.lines.dup
  if node.title.to_s.match?(ENRICHMENT_ID_PATTERN)
    lines = compact_provenance_drawer(lines, defaults)
  end
  out.concat(lines)

  node.children.each { |child| out.concat(render_node(child, defaults, learner_priority_sense_ids)) }
  out
end

# Determines which sense IDs receive LEARNER_PRIORITY: sense 1 by default,
# or whichever sense(s) already carry authored examples when sense 1 has
# none and another sense does (matches "where existing examples live").
def learner_priority_sense_ids(root)
  sense_nodes = root.children.select { |n| n.title&.start_with?('Sense ') }
  return [] if sense_nodes.empty?

  senses_with_examples = sense_nodes.select do |sense|
    sense.children.any? { |c| c.heading_name == 'Examples' && c.children.any? }
  end

  target =
    if senses_with_examples.empty?
      [sense_nodes.first]
    else
      senses_with_examples
    end

  target.map { |n| n.title[/s-\d+-\d+/] }
end

def extract_file_keywords(lines)
  keywords = {}
  order = []
  lines.each do |line|
    next unless line =~ /^#\+([A-Z0-9_]+):\s?(.*)$/

    keywords[Regexp.last_match(1)] = Regexp.last_match(2)
    order << Regexp.last_match(1)
  end
  [order, keywords]
end

# Canonicalizes English-gloss and Russian-reference content so the
# heading-with-drawer form (schema v1) and the compact list-item form
# (schema v2) produce identical fingerprint keys. A sense may legitimately
# mix both forms in the same subsection (v2: a plain gloss compacted to a
# list item alongside a non-default gloss kept as its own heading), so both
# the subsection's own list items and its child headings are read, not
# either/or.
def gloss_and_ref_content(root)
  keys = []

  root.children.each do |sense|
    next unless sense.title&.start_with?('Sense ')

    sense.children.each do |sub|
      case sub.heading_name
      when 'English glosses'
        sub.lines.each { |l| keys << "GLOSS:#{l.sub(/^- /, '')}" if l.start_with?('- ') }
        sub.children.each do |child|
          _, end_index, = drawer_properties(child.lines)
          text = child.lines[(end_index + 1)..].find { |l| l.start_with?('- text :: ') }.sub('- text :: ', '')
          keys << "GLOSS:#{text}"
        end
      when 'Russian reference'
        sub.lines.each do |l|
          next unless l.start_with?('- ')

          keys << "RUREF:#{l.sub(/^-\s*\d+\s*::\s*/, '').sub(/^- /, '')}"
        end
        sub.children.each do |child|
          _, end_index, = drawer_properties(child.lines)
          text = child.lines[(end_index + 1)..].find { |l| l.start_with?('- text :: ') }.sub('- text :: ', '')
          keys << "RUREF:#{text}"
        end
      end
    end
  end

  keys
end

DEFAULTED_PROVENANCE_KEYS = %w[SOURCE_TYPE AUTHOR_ID LICENSE STATUS CREATED_AT].freeze

def enrichment_nodes(root)
  nodes = []
  walk = lambda do |node|
    nodes << node if node.title.to_s.match?(ENRICHMENT_ID_PATTERN)
    node.children.each(&walk)
  end
  root.children.each(&walk)
  nodes
end

# The per-file default for each provenance key is whichever value is most
# common among that file's authored blocks, falling back to the project-wide
# convention when the file has no blocks carrying that key at all (e.g. no
# examples yet). A file's authored blocks share one author/license/source
# type/status in practice, so this reduces to that one value.
def file_provenance_defaults(root)
  blocks = enrichment_nodes(root)

  FILE_LEVEL_PROVENANCE_DEFAULTS.keys.each_with_object({}) do |key, result|
    values = blocks.filter_map { |node| node.lines.find { |l| l =~ /^:#{key}:\s?(.*)$/ } && $~[1] }.reject(&:empty?)
    result[key] = values.tally.max_by { |_, count| count }&.first || FILE_LEVEL_PROVENANCE_DEFAULTS[key]
  end
end

def content_fingerprint(text)
  lines = text.split("\n")
  content = []

  content.concat(lines.grep(/^#\+(TITLE|JMDICT_ID|PRIMARY_READING|ROMAJI|ENTRY_STATUS|QUALITY_PROFILE|JMDICT_SOURCE_SHA256):/))

  file_created_at = lines.find { |l| l.start_with?('#+CREATED_AT:') }&.sub('#+CREATED_AT:', '')&.strip

  body_start = lines.index { |l| l.start_with?('* ') }
  root = body_start ? parse_tree(lines[body_start..]) : nil

  # A v2 file declares its resolved defaults explicitly via #+DEFAULT_*; a v1
  # file has none, so the defaults must be inferred the same way migration
  # infers them (majority value among enrichment blocks). Recomputing v2's
  # defaults from its own already-compacted blocks would be circular: once a
  # value is compacted away for matching the default, it can no longer
  # contribute to "the majority," silently drifting the inferred default.
  provenance_defaults =
    if lines.any? { |l| l.start_with?('#+DEFAULT_') }
      {
        'SOURCE_TYPE' => lines.find { |l| l.start_with?('#+DEFAULT_SOURCE_TYPE:') }&.split(':', 2)&.last&.strip,
        'AUTHOR_ID' => lines.find { |l| l.start_with?('#+DEFAULT_AUTHOR_ID:') }&.split(':', 2)&.last&.strip,
        'LICENSE' => lines.find { |l| l.start_with?('#+DEFAULT_LICENSE:') }&.split(':', 2)&.last&.strip,
        'STATUS' => lines.find { |l| l.start_with?('#+DEFAULT_STATUS:') }&.split(':', 2)&.last&.strip
      }
    elsif root
      file_provenance_defaults(root)
    else
      FILE_LEVEL_PROVENANCE_DEFAULTS
    end
  content.concat(gloss_and_ref_content(root)) if root

  # English glosses and Russian reference content (both the v1 heading form
  # and the v2 compact list form) are fully accounted for via
  # gloss_and_ref_content above, so every line belonging to either
  # subsection — its own list items and any en-s-/ru-ref- child heading — is
  # skipped here to avoid double-counting.
  skip_depth = nil
  lines.each do |line|
    if line =~ /^(\*+)\s+(.*)$/
      level = Regexp.last_match(1).length
      title = Regexp.last_match(2)

      skip_depth = nil if skip_depth && level <= skip_depth
      skip_depth = level if %w[English\ glosses Russian\ reference].include?(title)

      content << "ID:#{title[/((?:wf|rd|s|note-s|col-s|con-s|rel-s|idiom-s|ex|accent-rd|audio-rd)-[\w-]+)/, 1]}" if title.match?(/^(?:wf|rd|s|note-s|col-s|con-s|rel-s|idiom-s|ex|accent-rd|audio-rd)-/)
      next
    end
    next if skip_depth

    case line
    when /^:(TEXT|NO_KANJI|SOURCE_SENSE_INDEX|SOURCE_FINGERPRINT|LANG|TYPE|GENDER|PRIMARY|STATUS|TRANSLATOR_ID|TRANSLATED_AT|REVIEWER_ID|REVIEWED_AT|SOURCE_TYPE|AUTHOR_ID|LICENSE|CREATED_AT|LEVEL|REGISTER|SOURCE_ID|SOURCE_URL):\s?(.*)$/
      key = Regexp.last_match(1)
      value = Regexp.last_match(2)
      # A provenance property that equals the file-wide default (or, for
      # CREATED_AT, the file's own #+CREATED_AT) resolves identically whether
      # written explicitly or inherited via §5/§9 — that is the compaction
      # schema v2 permits, not lost information, so both surface forms
      # collapse to the same absent key here.
      next if key == 'CREATED_AT' && value == file_created_at
      next if DEFAULTED_PROVENANCE_KEYS.include?(key) && value == provenance_defaults[key]

      content << "PROP:#{key}=#{value}"
    when /^- (?:text|qualifier|JA|READING|ROMAJI|UK|EN|FOCUS|PATTERN|RELATION|TARGET|TARGET_ID|LEVEL|REGISTER) :: (.*)$/
      content << "FIELD:#{line.strip}"
    when /^-\s+(\S.*)$/
      value = Regexp.last_match(1)
      next if value == '*'

      content << "ITEM:#{value}"
    end
  end

  content.sort
end

def migrate_file(path)
  original_text = File.read(path, encoding: 'UTF-8')
  lines = original_text.split("\n")

  order, keywords = extract_file_keywords(lines)
  raise "#{path}: not schema version 1" unless keywords['SCHEMA_VERSION'] == '1'

  body_start = lines.index { |l| l.start_with?('* ') }
  root = parse_tree(lines[body_start..])

  provenance_defaults = file_provenance_defaults(root)
  defaults = {
    provenance: provenance_defaults,
    created_at: keywords['CREATED_AT']
  }

  priority_ids = learner_priority_sense_ids(root)

  new_body = root.children.flat_map { |node| render_node(node, defaults, priority_ids) }

  new_header = []
  order.each do |key|
    next if key == 'UPDATED_AT'

    value = key == 'SCHEMA_VERSION' ? '2' : keywords[key]
    new_header << "#+#{key}: #{value}"
  end
  new_header << "#+DEFAULT_AUTHOR_ID: #{provenance_defaults['AUTHOR_ID']}"
  new_header << "#+DEFAULT_LICENSE: #{provenance_defaults['LICENSE']}"
  new_header << "#+DEFAULT_SOURCE_TYPE: #{provenance_defaults['SOURCE_TYPE']}"
  new_header << "#+DEFAULT_STATUS: #{provenance_defaults['STATUS']}"

  new_text = (new_header + [''] + new_body).join("\n") + "\n"

  before_tally = content_fingerprint(original_text).tally
  after_tally = content_fingerprint(new_text).tally

  if before_tally != after_tally
    keys = (before_tally.keys | after_tally.keys).select { |k| before_tally[k].to_i != after_tally[k].to_i }
    diffs = keys.first(10).map { |k| "#{k.inspect}: before=#{before_tally[k].to_i} after=#{after_tally[k].to_i}" }
    raise "#{path}: content mismatch after migration\n  #{diffs.join("\n  ")}"
  end

  File.write(path, new_text)
end

if __FILE__ == $PROGRAM_NAME
  paths = ARGV.empty? ? Dir['entries/*/*.org'].sort : ARGV
  failures = []

  paths.each do |path|
    migrate_file(path)
    puts "migrated #{path}"
  rescue StandardError => e
    failures << "#{path}: #{e.message}"
  end

  if failures.any?
    warn "\n#{failures.length} failure(s):"
    failures.each { |f| warn "- #{f}" }
    exit 1
  end

  puts "\nMigrated #{paths.length} file(s) with zero content loss."
end
