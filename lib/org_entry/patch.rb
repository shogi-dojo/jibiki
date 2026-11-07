# frozen_string_literal: true

require 'date'

module OrgEntry
  # Edits the authored (Ukrainian and enrichment) layer of one entry file,
  # line by line.
  #
  # The parser is not lossless (comments, wrapping and drawer order are not
  # kept), so an edit never re-renders the file. It finds the heading an
  # operation names by its stable ID and rewrites only that block's lines;
  # every other byte of the file stays as it was.
  #
  #   text = OrgEntry::Patch.apply(text, ops, author: 'dojo:olena',
  #                                reviewer: 'dojo:taras', date: '2026-11-08')
  #
  # Operations are plain hashes with string keys, so they can travel as JSON:
  #
  #   { 'op' => 'gloss.add',  'sense' => 's-1381380-001', 'values' => { 'text' => 'лазур' } }
  #   { 'op' => 'gloss.edit', 'id' => 'uk-s-1381380-001-002',
  #     'from' => { 'text' => 'блакитний колір' }, 'values' => { 'text' => 'блакитний' } }
  #   { 'op' => 'gloss.remove',  'id' => '…', 'from' => { 'text' => '…' } }
  #   { 'op' => 'gloss.confirm', 'id' => '…', 'from' => { 'text' => '…' } }
  #   { 'op' => 'entry.delete' }
  #
  # The same shapes exist for `note`, `example` and `collocation`. `from` holds
  # the values the author saw; when the file no longer has them the edit raises
  # Conflict instead of overwriting someone else's change. An `add` may name
  # an `after` ID to place the new block behind it.
  #
  # `author` is who wrote the change. `reviewer`, when given, is who approved
  # it: changed blocks then become `reviewed`, unless the reviewer is the author
  # (docs/org-format.md §8.4). A `confirm` records the author as the reviewer of
  # an existing block and is refused for its own translator or author.
  #
  # Returns the new text, or nil when the entry was deleted.
  module Patch
    class Error < StandardError
      attr_reader :op_index

      def initialize(message, op_index = nil)
        super(op_index ? "operation #{op_index + 1}: #{message}" : message)
        @op_index = op_index
      end
    end

    # The file changed under the edit: an ID is gone or a value differs from `from`.
    class Conflict < Error; end

    # The operation itself is malformed.
    class Invalid < Error; end

    Field = Data.define(:name, :label, :place)

    # A kind of authored block: where it lives and which fields it carries.
    # `place` is :list for `- LABEL :: value` items and :drawer for properties.
    Kind = Data.define(:name, :section, :fields, :required, :person_key, :date_key, :levels) do
      def field(name) = fields.find { |candidate| candidate.name == name }
      def gloss? = name == 'gloss'
    end

    NOTE_LEVELS = %w[beginner intermediate advanced].freeze
    EXAMPLE_LEVELS = %w[beginner neutral intermediate advanced].freeze

    KINDS = {
      'gloss' => Kind.new(
        name: 'gloss', section: 'Ukrainian glosses',
        fields: [Field.new('text', 'text', :list), Field.new('qualifier', 'qualifier', :list)],
        required: %w[text], person_key: 'TRANSLATOR_ID', date_key: 'TRANSLATED_AT', levels: nil
      ),
      'note' => Kind.new(
        name: 'note', section: 'Learner notes',
        fields: [Field.new('uk', 'UK', :list), Field.new('level', 'LEVEL', :list),
                 Field.new('register', 'REGISTER', :list)],
        required: %w[uk], person_key: 'AUTHOR_ID', date_key: 'CREATED_AT', levels: NOTE_LEVELS
      ),
      'example' => Kind.new(
        name: 'example', section: 'Examples',
        fields: [Field.new('level', 'LEVEL', :drawer), Field.new('register', 'REGISTER', :drawer),
                 Field.new('ja', 'JA', :list), Field.new('reading', 'READING', :list),
                 Field.new('romaji', 'ROMAJI', :list), Field.new('uk', 'UK', :list),
                 Field.new('en', 'EN', :list), Field.new('focus', 'FOCUS', :list)],
        required: %w[ja reading uk], person_key: 'AUTHOR_ID', date_key: 'CREATED_AT', levels: EXAMPLE_LEVELS
      ),
      'collocation' => Kind.new(
        name: 'collocation', section: 'Collocations',
        fields: [Field.new('ja', 'JA', :list), Field.new('reading', 'READING', :list),
                 Field.new('uk', 'UK', :list), Field.new('pattern', 'PATTERN', :list),
                 Field.new('register', 'REGISTER', :list)],
        required: %w[ja reading uk], person_key: 'AUTHOR_ID', date_key: 'CREATED_AT', levels: nil
      )
    }.freeze

    ACTIONS = %w[add edit remove confirm].freeze

    # Sense subsections in their required order (docs/org-format.md §8).
    SENSE_SECTIONS = [
      'Applies to forms', 'JMdict metadata', 'English glosses', 'Ukrainian glosses',
      'Russian reference', 'Learner notes', 'Collocations', 'Constructions and derivatives',
      'Related words', 'Idioms and proverbs', 'Examples'
    ].freeze

    # Sections that stay even when empty (§15); the rest go with their last item.
    KEPT_SECTIONS = ['Applies to forms', 'JMdict metadata', 'English glosses', 'Ukrainian glosses'].freeze

    ID_KINDS = { 'uk-' => 'gloss', 'note-' => 'note', 'ln-' => 'note', 'ex-' => 'example', 'col-' => 'collocation' }.freeze

    HEADING = /\A(\*+) (.*)\z/
    PERSON = /\A[a-z0-9][a-z0-9:._-]*\z/

    module_function

    def apply(text, ops, author:, date:, reviewer: nil)
      raise Invalid, 'operations must be a non-empty list' unless ops.is_a?(Array) && !ops.empty?
      raise Invalid, "author #{author.inspect} is not a contributor ID" unless author.to_s.match?(PERSON)
      raise Invalid, "reviewer #{reviewer.inspect} is not a contributor ID" if reviewer && !reviewer.match?(PERSON)

      date = Date.iso8601(date.to_s).iso8601
      if ops.any? { |op| op.is_a?(Hash) && op['op'] == 'entry.delete' }
        raise Invalid, 'entry.delete must be the only operation' unless ops.length == 1

        return nil
      end

      editor = Editor.new(text, author: author, reviewer: reviewer, date: date)
      ops.each_with_index do |op, index|
        editor.run(op)
      rescue Error => e
        raise e.class.new(e.message, index)
      end
      editor.finish
    rescue Date::Error
      raise Invalid, "date #{date.inspect} is not an ISO 8601 date"
    end

    # The current values of one block, as the parser would read them. Returns
    # nil when no heading has that ID.
    def read(text, id)
      reader(text).values(id)
    end

    # An editor for reading several blocks of one file: `reader(text).values(id)`.
    def reader(text)
      Editor.new(text, author: 'reader', reviewer: nil, date: Date.today.iso8601)
    end

    # Applies operations to an array of lines.
    class Editor
      def initialize(text, author:, reviewer:, date:)
        @trailing_newline = text.end_with?("\n")
        @lines = text.lines(chomp: true)
        @original = @lines.dup
        @author = author
        @reviewer = reviewer
        @date = date
        @defaults = keywords.select { |key, _| key.start_with?('DEFAULT_') }
                            .transform_keys { |key| key.delete_prefix('DEFAULT_') }
      end

      def run(op)
        raise Invalid, 'an operation must be an object' unless op.is_a?(Hash)

        kind_name, action = op['op'].to_s.split('.', 2)
        kind = KINDS[kind_name]
        raise Invalid, "unknown operation #{op['op'].inspect}" unless kind && ACTIONS.include?(action)

        send(action, kind, op)
      end

      def finish
        return @original.join("\n") + (@trailing_newline ? "\n" : '') if @lines == @original

        update_entry_status
        set_keyword('UPDATED_AT', @date, after: 'CREATED_AT')
        @lines.join("\n") + (@trailing_newline ? "\n" : '')
      end

      def values(id)
        kind = KINDS[kind_for(id).to_s]
        index = kind && heading_index(id)
        return nil unless index

        kind.fields.to_h { |field| [field.name, read_field(index, field)] }
      end

      private

      # --- operations -----------------------------------------------------

      def add(kind, op)
        sense = op['sense'].to_s
        sense_index = heading_index("Sense #{sense}", level: 1)
        raise Conflict, "sense #{sense.inspect} not found" unless sense_index

        values = clean_values(kind, op['values'])
        missing = kind.required.reject { |name| values[name] }
        raise Invalid, "#{kind.name} needs #{missing.join(', ')}" unless missing.empty?

        id = next_id(kind, sense)
        position = insert_position(kind, sense_index, op['after'])
        @lines.insert(position, "*** #{id}", ':PROPERTIES:', ':END:')
        index = position
        kind.fields.each { |field| write_field(index, field, values[field.name]) }
        write_provenance(index, kind, created: true)
      end

      def edit(kind, op)
        index = locate(kind, op)
        values = clean_values(kind, op['values'])
        raise Invalid, 'edit needs values' if values.empty?

        values.each do |name, value|
          raise Invalid, "#{kind.name} needs #{name}" if value.nil? && kind.required.include?(name)
        end
        before = values(op['id'])
        values.each { |name, value| write_field(index, kind.field(name), value) }
        return if values(op['id']) == before

        write_provenance(index, kind, created: false)
      end

      def remove(kind, op)
        index = locate(kind, op)
        @lines.slice!(index...block_end(index))
        drop_empty_section(index)
      end

      def confirm(kind, op)
        index = locate(kind, op)
        person = property(index, kind.person_key) || @defaults['AUTHOR_ID']
        raise Invalid, "#{@author} cannot confirm their own #{kind.name}" if person == @author

        set_property(index, 'REVIEWER_ID', @author)
        set_property(index, 'REVIEWED_AT', @date)
        set_status(index, 'reviewed')
      end

      # --- locating blocks ------------------------------------------------

      def locate(kind, op)
        id = op['id'].to_s
        raise Invalid, "#{kind.name} #{id.inspect} is not a #{kind.name} ID" unless kind_for(id) == kind.name

        index = heading_index(id)
        raise Conflict, "#{id} no longer exists" unless index

        from = op['from']
        raise Invalid, 'from must be an object' unless from.nil? || from.is_a?(Hash)

        current = values(id)
        (from || {}).each do |name, expected|
          raise Invalid, "#{kind.name} has no field #{name.inspect}" unless kind.field(name)
          next if normalize(expected) == current[name]

          raise Conflict, "#{id} #{name} is now #{current[name].inspect}, not #{expected.inspect}"
        end
        index
      end

      def kind_for(id)
        ID_KINDS.find { |prefix, _| id.start_with?(prefix) }&.last
      end

      def heading_index(title, level: nil)
        headings[title]&.find { |_, stars| level.nil? || stars == level }&.first
      end

      # title => [[line index, level], ...], rebuilt whenever the lines change.
      def headings
        key = @lines.hash
        return @headings if @headings_key == key

        @headings_key = key
        @headings = Hash.new { |hash, title| hash[title] = [] }
        @lines.each_with_index do |line, index|
          next unless line.start_with?('*') && (match = line.match(HEADING))

          @headings[match[2]] << [index, match[1].length]
        end
        @headings.default_proc = nil
        @headings
      end

      def level_at(index)
        @lines[index][HEADING, 1].length
      end

      # The index after a heading's subtree.
      def block_end(index)
        level = level_at(index)
        stop = ((index + 1)...@lines.length).find do |candidate|
          (stars = @lines[candidate][HEADING, 1]) && stars.length <= level
        end
        stop || @lines.length
      end

      # Like block_end, but before the blank lines that separate the subtree
      # from what follows.
      def content_end(index)
        stop = block_end(index)
        stop -= 1 while stop > index + 1 && @lines[stop - 1].empty?
        stop
      end

      def section_index(sense_index, title)
        ((sense_index + 1)...block_end(sense_index)).find { |index| @lines[index] == "** #{title}" }
      end

      def insert_position(kind, sense_index, after)
        if after
          after_index = heading_index(after.to_s)
          unless after_index && kind_for(after.to_s) == kind.name && sense_of(after_index) == sense_index
            raise Conflict, "#{after} is not a #{kind.name} of this sense"
          end

          return content_end(after_index)
        end

        section = section_index(sense_index, kind.section) || create_section(kind.section, sense_index)
        content_end(section)
      end

      def sense_of(index)
        index.downto(0).find { |candidate| @lines[candidate].start_with?('* ') }
      end

      def create_section(title, sense_index)
        later = SENSE_SECTIONS.drop(SENSE_SECTIONS.index(title) + 1)
        following = later.filter_map { |name| section_index(sense_index, name) }.min
        position = following || content_end(sense_index)
        @lines.insert(position, "** #{title}")
        position
      end

      def drop_empty_section(index)
        section = (index - 1).downto(0).find { |candidate| @lines[candidate].match?(/\A\*{1,2} /) }
        return unless section && @lines[section].start_with?('** ')

        title = @lines[section].delete_prefix('** ')
        return if KEPT_SECTIONS.include?(title) || !SENSE_SECTIONS.include?(title)
        return unless @lines[(section + 1)...block_end(section)].all?(&:empty?)

        @lines.delete_at(section)
      end

      # --- IDs ------------------------------------------------------------

      # One past the highest number in use for this kind and sense, so IDs are
      # never renumbered (§17). Examples also count the legacy `ex-s-` form.
      def next_id(kind, sense)
        bare = sense.delete_prefix('s-')
        prefixes = case kind.name
                   when 'gloss' then ["uk-#{sense}-"]
                   when 'note' then ["note-#{sense}-", "ln-#{sense}-"]
                   when 'collocation' then ["col-#{sense}-"]
                   else ["ex-#{bare}-", "ex-#{sense}-"]
                   end
        numbers = @lines.filter_map do |line|
          title = line[HEADING, 2]
          prefix = title && prefixes.find { |candidate| title.start_with?(candidate) }
          title.delete_prefix(prefix)[/\A(\d{3})\z/, 1]&.to_i if prefix
        end
        "#{prefixes.first}#{format('%03d', (numbers.max || 0) + 1)}"
      end

      # --- fields ---------------------------------------------------------

      def clean_values(kind, values)
        raise Invalid, 'values must be an object' unless values.nil? || values.is_a?(Hash)

        (values || {}).to_h do |name, value|
          raise Invalid, "#{kind.name} has no field #{name.inspect}" unless kind.field(name)

          value = normalize(value)
          if value&.match?(/[\r\n\t]/) || value&.start_with?('*')
            raise Invalid, "#{name} must be a single line of text"
          end
          if value && kind.levels && name == 'level' && !kind.levels.include?(value)
            raise Invalid, "level must be one of #{kind.levels.join(', ')}"
          end
          if value && name == 'register' && !value.match?(/\A[a-z-]+\z/)
            raise Invalid, 'register must be a lowercase word'
          end

          [name, value]
        end
      end

      def normalize(value)
        return nil if value.nil?

        text = value.to_s.unicode_normalize(:nfc).strip.gsub(/ {2,}/, ' ')
        text.empty? ? nil : text
      end

      def read_field(index, field)
        return property(index, field.label) if field.place == :drawer

        start, stop = list_item(index, field.label)
        if start.nil? && field.name == 'text'
          start, stop = first_unlabeled_item(index)
          return nil unless start

          value = @lines[start].delete_prefix('- ')
          return nil if value == 'text ::'
        else
          return nil unless start

          value = @lines[start].split(' :: ', 2).last
        end
        normalize(([value] + @lines[(start + 1)...stop].map(&:strip)).join(' '))
      end

      def write_field(index, field, value)
        return set_property(index, field.label, value) if field.place == :drawer

        start, stop = list_item(index, field.label)
        start, stop = first_unlabeled_item(index) if start.nil? && field.name == 'text'
        line = "- #{field.label} :: #{value}"
        if start
          value ? @lines[start...stop] = [line] : @lines.slice!(start...stop)
        elsif value
          @lines.insert(list_insert_position(index, field), line)
        end
      end

      # [first line, index after its continuation lines] of the `- LABEL ::` item.
      def list_item(index, label)
        body(index).each do |line_index|
          next unless @lines[line_index].start_with?("- #{label} :: ")

          return [line_index, continuation_end(line_index)]
        end
        [nil, nil]
      end

      def first_unlabeled_item(index)
        line_index = body(index).find { |candidate| @lines[candidate].start_with?('- ') && !@lines[candidate].include?(' :: ') }
        line_index ? [line_index, continuation_end(line_index)] : [nil, nil]
      end

      def continuation_end(line_index)
        stop = line_index + 1
        stop += 1 while @lines[stop]&.start_with?('  ')
        stop
      end

      # Keep list items in the kind's field order.
      def list_insert_position(index, field)
        kind = KINDS.fetch(kind_for(@lines[index][HEADING, 2]))
        earlier = kind.fields.take_while { |candidate| candidate != field }.select { |candidate| candidate.place == :list }
        last = earlier.filter_map { |candidate| list_item(index, candidate.label)[1] }.max
        last || drawer_end(index) + 1
      end

      # Line indexes of the block's own lines (before any child heading).
      def body(index)
        stop = ((index + 1)...@lines.length).find { |candidate| @lines[candidate].match?(HEADING) } || @lines.length
        ((index + 1)...stop).to_a
      end

      # --- drawer ---------------------------------------------------------

      def drawer_end(index)
        unless @lines[index + 1] == ':PROPERTIES:'
          @lines.insert(index + 1, ':PROPERTIES:', ':END:')
        end
        ((index + 2)...@lines.length).find { |candidate| @lines[candidate] == ':END:' }
      end

      def property_index(index, key)
        return nil unless @lines[index + 1] == ':PROPERTIES:'

        ((index + 2)...drawer_end(index)).find { |candidate| @lines[candidate].match?(/\A:#{key}:( |\z)/) }
      end

      def property(index, key)
        line_index = property_index(index, key)
        line_index && normalize(@lines[line_index].sub(/\A:#{key}:/, ''))
      end

      # nil removes the property; '' writes it empty, as reviewer slots are.
      def set_property(index, key, value)
        line_index = property_index(index, key)
        line = value.to_s.empty? ? ":#{key}:" : ":#{key}: #{value}"
        if value.nil?
          @lines.delete_at(line_index) if line_index
        elsif line_index
          @lines[line_index] = line
        else
          @lines.insert(drawer_end(index), line)
        end
      end

      # A drawer omits values equal to the file defaults (§9).
      def set_default_aware(index, key, value, default)
        set_property(index, key, value == default ? nil : value)
      end

      def set_status(index, status)
        set_default_aware(index, 'STATUS', status, @defaults['STATUS'] || 'draft')
      end

      # The author now owns the block's text; an independent approval makes it
      # reviewed, anything else leaves it a draft awaiting review.
      def write_provenance(index, kind, created:)
        reviewed = @reviewer && @reviewer != @author
        if kind.gloss?
          set_property(index, 'TRANSLATOR_ID', @author)
          set_property(index, 'TRANSLATED_AT', @date)
          set_property(index, 'REVIEWER_ID', reviewed ? @reviewer : '')
          set_property(index, 'REVIEWED_AT', reviewed ? @date : '')
        else
          set_default_aware(index, 'AUTHOR_ID', @author, @defaults['AUTHOR_ID'])
          set_default_aware(index, 'CREATED_AT', @date, keywords['CREATED_AT']) if created
          set_property(index, 'REVIEWER_ID', reviewed ? @reviewer : nil)
          set_property(index, 'REVIEWED_AT', reviewed ? @date : nil)
        end
        if created
          set_default_aware(index, 'SOURCE_TYPE', 'original', @defaults['SOURCE_TYPE'] || 'original')
          set_default_aware(index, 'LICENSE', 'CC-BY-SA-4.0', @defaults['LICENSE'] || 'CC-BY-SA-4.0')
        end
        set_status(index, reviewed ? 'reviewed' : 'draft')
      end

      # --- file keywords --------------------------------------------------

      def keywords
        @lines.take_while { |line| line.start_with?('#+') }
              .to_h { |line| line.delete_prefix('#+').split(':', 2).map(&:strip) }
      end

      def set_keyword(key, value, after:)
        existing = @lines.index { |line| line.start_with?("#+#{key}:") }
        line = "#+#{key}: #{value}"
        return @lines[existing] = line if existing

        anchor = @lines.index { |line| line.start_with?("#+#{after}:") }
        @lines.insert(anchor ? anchor + 1 : keywords.length, line)
      end

      # An entry is reviewed once every Ukrainian gloss in it is (§5, §18).
      def update_entry_status
        status = keywords['ENTRY_STATUS']
        glosses = @lines.each_index.select { |index| @lines[index].match?(/\A\*{3} uk-/) }
        statuses = glosses.map { |index| property(index, 'STATUS') || @defaults['STATUS'] || 'draft' }
        new_status = if statuses.empty? then status
                     elsif statuses.all?('reviewed') then 'reviewed'
                     elsif status == 'reviewed' || status == 'untranslated' then 'draft'
                     else status
                     end
        set_keyword('ENTRY_STATUS', new_status, after: 'ROMAJI') if new_status != status
      end
    end
  end
end
