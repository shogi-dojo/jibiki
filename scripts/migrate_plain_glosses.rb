#!/usr/bin/env ruby
# frozen_string_literal: true

# One-time migration: give every plain Ukrainian gloss a stable heading ID.
#
# A plain gloss is a bare list item directly under `** Ukrainian glosses`:
#
#   ** Ukrainian glosses
#   - розгублено
#
# The parser names such items by their position (`uk-<sense>-NNN`), so the
# name moves when an item is added or removed. Web contributions address
# glosses by ID, so each item becomes the heading form the parser already
# names it after:
#
#   ** Ukrainian glosses
#   *** uk-s-1012110-001-001
#   :PROPERTIES:
#   :END:
#   - text :: розгублено
#
# The heading takes the exact ID the parser assigned, and the new headings go
# before any existing gloss headings, so the parsed model (IDs, order, text,
# provenance) is unchanged. `--check` proves that for every file it touches.
#
#   ruby scripts/migrate_plain_glosses.rb [--check] [PATH ...]

require_relative '../lib/org_entry'

module PlainGlossMigration
  SECTION = '** Ukrainian glosses'
  HEADING = /\A\*+ /

  module_function

  # Returns the migrated text, or the input unchanged when the file has no
  # plain glosses.
  def migrate(text)
    lines = text.lines(chomp: true)
    output = []
    sense_id = nil
    index = 0

    while index < lines.length
      line = lines[index]
      sense_id = line[/\A\* Sense (\S+)/, 1] if line.start_with?('* ')
      output << line
      index += 1
      next unless line == SECTION && sense_id

      items, index = take_plain_items(lines, index)
      next if items.empty?

      reserved = reserved_ids(lines, index)
      ids = plain_ids(sense_id, items.length, reserved)
      items.zip(ids).each do |item_lines, id|
        output << "*** #{id}" << ':PROPERTIES:' << ':END:'
        output << item_lines.first.sub(/\A- /, '- text :: ')
        output.concat(item_lines.drop(1))
      end
    end

    trailing_newline = text.end_with?("\n") ? "\n" : ''
    output.join("\n") + trailing_newline
  end

  # Plain items run from just after the section heading to the first heading;
  # an item's continuation lines are indented.
  def take_plain_items(lines, index)
    items = []
    while index < lines.length && !lines[index].match?(HEADING)
      line = lines[index]
      if line.start_with?('- ')
        items << [line]
      elsif items.any? && line.start_with?(' ')
        items.last << line
      else
        break
      end
      index += 1
    end
    [items, index]
  end

  # Heading gloss IDs already in the section, which plain IDs must skip, the
  # way the parser skips them.
  def reserved_ids(lines, index)
    ids = []
    while index < lines.length && !lines[index].start_with?('* ', '** ')
      id = lines[index][/\A\*\*\* (uk-s-\S+)\z/, 1]
      ids << id if id
      index += 1
    end
    ids
  end

  def plain_ids(sense_id, count, reserved)
    ids = []
    number = 1
    while ids.length < count
      candidate = "uk-#{sense_id}-#{format('%03d', number)}"
      ids << candidate unless reserved.include?(candidate)
      number += 1
    end
    ids
  end

  # The parsed model as plain data, for before/after comparison.
  def snapshot(text)
    dump(OrgEntry.parse(text), {})
  end

  def dump(value, seen)
    case value
    when Array then value.map { |item| dump(item, seen) }
    when Hash then value.transform_values { |item| dump(item, seen) }
    when String, Symbol, Numeric, true, false, nil then value
    else
      return :cycle if seen[value.object_id]

      seen[value.object_id] = true
      fields = value.instance_variables.reject { |name| %i[@parent @entry @document @source].include?(name) }
      [value.class.name, fields.to_h { |name| [name, dump(value.instance_variable_get(name), seen)] }]
    end
  end
end

if $PROGRAM_NAME == __FILE__
  check = ARGV.delete('--check')
  paths = ARGV.empty? ? Dir[File.expand_path('../entries/*/*.org', __dir__)].sort : ARGV
  changed = 0
  failures = []

  paths.each do |path|
    original = File.read(path, encoding: 'UTF-8')
    migrated = PlainGlossMigration.migrate(original)
    next if migrated == original

    if PlainGlossMigration.snapshot(original) != PlainGlossMigration.snapshot(migrated)
      failures << path
      next
    end

    changed += 1
    File.write(path, migrated) unless check
  end

  puts "#{check ? 'Would migrate' : 'Migrated'} #{changed} file(s)."
  unless failures.empty?
    warn "Parsed model changed, left untouched:\n  #{failures.join("\n  ")}"
    exit 1
  end
end
