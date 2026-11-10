# frozen_string_literal: true

# A native subset of Emacs `org-lint` for dictionary entries.
#
# Entries use a narrow slice of Org (file keywords, headings, property drawers,
# description lists, the odd numbered list and link), so only the org-lint
# checkers that can fire on that slice are restated here, with Emacs's checker
# names, line numbers and messages. test/org_lint_test.rb holds the two to the
# same findings on broken entries; `rake org:lint` still runs Emacs over the
# whole corpus as the authority. This file needs no gem and compiles under
# Spinel, so `jb lint` skips Emacs's ~1 s start-up on every batch.
module OrgLint
  Finding = Data.define(:line, :checker, :message)

  HEADING = /\A\*+[ \t]/
  DRAWER = /\A[ \t]*:([\w-]+):[ \t]*\z/
  DRAWER_END = /\A[ \t]*:END:[ \t]*\z/i
  PROPERTIES_START = /\A[ \t]*:PROPERTIES:[ \t]*\z/i
  NODE_PROPERTY = /\A[ \t]*:\S+:(?:[ \t].*)?\z/
  BLOCK_BEGIN = /\A[ \t]*#\+BEGIN_(\S+)/i
  ITEM = /\A([ \t]*)([-+]|[ \t]+\*|\d+[.)]|[A-Za-z][.)])([ \t]+|\z)(?:\[@(\d+)\][ \t]*)?/
  LINK = /\[\[([^\[\]]+)\](?:\[(?:[^\[\]]|\[[^\[\]]*\])*\])?\]/
  TIMESTAMP = /[<\[](\d{4})-(\d{2})-(\d{2})(?: +[^\s\d>\]<\[]+\.?)?(?: +(\d{1,2}):(\d{2}))?[^>\]<\[\n]*?[>\]]/
  AFFILIATED = /\A[ \t]*#\+(CAPTION|DATA|HEADERS?|LABEL|NAME|PLOT|RESNAME|RESULTS?|SOURCE|SRCNAME|TBLNAME|ATTR_[-\w]+)(?:\[.*\])?:/i
  SPECIAL_PROPERTIES = %w[ALLTAGS BLOCKED CLOCKSUM CLOCKSUM_T CLOSED DEADLINE FILE ITEM PRIORITY SCHEDULED TAGS
                          TIMESTAMP TIMESTAMP_IA TODO].freeze
  EFFORT = /\A[ \t]*(?:\d+:\d{2}(?::\d{2})?|(?:\d+(?:\.\d+)?[ \t]*(?:min|h|d|w|m|y)[ \t]*)+|\d+(?:\.\d+)?)[ \t]*\z/
  DAYS_IN_MONTH = [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31].freeze

  module_function

  # Findings for one file, ordered by line.
  def lint_file(path)
    lint(File.binread(path).force_encoding('UTF-8'), dir: File.dirname(path))
  end

  # Findings for Org text. dir resolves relative file links.
  def lint(text, dir: '.')
    lines = text.split("\n", -1)
    lines.pop if lines.last == ''
    findings = []
    in_block = blocks(lines, findings)
    drawers(lines, in_block, findings)
    properties(lines, in_block, findings)
    keywords(lines, in_block, findings)
    headings(lines, findings)
    items(lines, in_block, findings)
    links(lines, in_block, dir, findings)
    footnotes(lines, in_block, findings)
    timestamps(lines, in_block, findings)
    findings.sort_by { |finding| finding.line }
  end

  # Marks the lines inside complete blocks (other checks skip them) and
  # reports a #+BEGIN_ with no #+END_ before the next heading.
  def blocks(lines, findings)
    in_block = Array.new(lines.length, false)
    i = 0
    while i < lines.length
      match = lines[i].match(BLOCK_BEGIN)
      if match
        finish = /\A[ \t]*#\+END_#{Regexp.escape(match[1])}[ \t]*\z/i
        j = i + 1
        j += 1 while j < lines.length && !lines[j].match?(HEADING) && !lines[j].match?(finish)
        if j < lines.length && lines[j].match?(finish)
          (i..j).each { |k| in_block[k] = true }
          i = j
        else
          findings << Finding.new(line: i + 1, checker: 'invalid-block',
                                  message: "Possible incomplete block \"#{lines[i].strip.split.first}\"")
        end
      end
      i += 1
    end
    in_block
  end

  # A drawer opening line needs an :END: before the next heading.
  def drawers(lines, in_block, findings)
    i = 0
    while i < lines.length
      match = in_block[i] ? nil : lines[i].match(DRAWER)
      if match
        j = i + 1
        j += 1 while j < lines.length && !lines[j].match?(HEADING) && !lines[j].match?(DRAWER_END)
        if j < lines.length && lines[j].match?(DRAWER_END)
          i = j
        else
          findings << Finding.new(line: i + 1, checker: 'incomplete-drawer',
                                  message: "Possible incomplete drawer \":#{match[1]}:\"")
        end
      end
      i += 1
    end
  end

  # A PROPERTIES drawer must sit right under its heading and hold only node
  # properties; within one, special and malformed EFFORT properties are flagged.
  def properties(lines, in_block, findings)
    i = 0
    while i < lines.length
      start = i
      i += 1
      next if in_block[start] || !lines[start].match?(PROPERTIES_START)

      finish = (i...lines.length).find { |j| lines[j].match?(HEADING) || lines[j].match?(DRAWER_END) }
      next if finish.nil? || lines[finish].match?(HEADING)

      i = finish + 1
      body = lines[(start + 1)...finish]
      placed = start.positive? && lines[start - 1].match?(HEADING)
      unless placed && body.all? { |prop| prop.match?(NODE_PROPERTY) }
        findings << Finding.new(line: start + 1, checker: 'obsolete-properties-drawer',
                                message: 'Incorrect contents for PROPERTIES drawer')
        next
      end

      body.each_with_index do |prop, offset|
        key = prop[/\A[ \t]*:(\S+?)\+?:/, 1].to_s.upcase
        value = prop.sub(/\A[ \t]*:\S+:/, '')
        if SPECIAL_PROPERTIES.include?(key)
          findings << Finding.new(line: start + 2 + offset, checker: 'special-property-in-properties-drawer',
                                  message: "Special property \"#{key}\" found in a properties drawer")
        elsif key == 'EFFORT' && !value.match?(EFFORT)
          findings << Finding.new(line: start + 2 + offset, checker: 'invalid-effort-property',
                                  message: "Invalid effort duration format: \"#{value.strip}\"")
        end
      end
    end
  end

  # `#+NAME` with no colon, and affiliated keywords attached to nothing.
  def keywords(lines, in_block, findings)
    lines.each_with_index do |line, i|
      next if in_block[i]

      missing = line.match(/\A[ \t]*#\+([^\s:]*)(?: |\z)/)
      if missing && !missing[1].empty? && !missing[1].match?(/\A(?:BEGIN|END)_/i)
        findings << Finding.new(line: i + 1, checker: 'invalid-keyword-syntax',
                                message: "Possible missing colon in keyword \"#{missing[1]}\"")
      end

      affiliated = line.match(AFFILIATED)
      next unless affiliated

      following = i + 1
      following += 1 while following < lines.length && lines[following].match?(AFFILIATED)
      next unless following >= lines.length || lines[following].strip.empty? || lines[following].match?(HEADING)

      findings << Finding.new(line: i + 1, checker: 'orphaned-affiliated-keywords',
                              message: "Orphaned affiliated keyword: \"#{affiliated[1].upcase}\"")
    end
  end

  def headings(lines, findings)
    lines.each_with_index do |line, i|
      next unless line.match?(HEADING)

      priority = line.match(/\A\*+[ \t]+(?:(?:TODO|DONE)[ \t]+)?\[#([^\]]*)\]/)
      if priority && !priority[1].match?(/\A[A-C]\z/)
        findings << Finding.new(line: i + 1, checker: 'priority', message: "Invalid priority '#{priority[1]}'")
      end

      tags = line[/[ \t](:[^ \t]*:)[ \t]*\z/, 1]
      next unless tags&.include?('::')

      findings << Finding.new(line: i + 1, checker: 'spurious-colons', message: 'Tags contain a spurious colon')
    end
  end

  # Ordered bullets must count their position in the list. A list ends at a
  # heading, at two blank lines, or at a line no deeper than its items.
  def items(lines, in_block, findings)
    stack = [] # [indent, position] per open list, innermost last
    blanks = 0
    lines.each_with_index do |line, i|
      if line.match?(HEADING) || in_block[i]
        stack.clear
        next
      end
      if line.strip.empty?
        blanks += 1
        stack.clear if blanks >= 2
        next
      end
      blanks = 0
      item = line.match(ITEM)
      indent = line[/\A[ \t]*/].length
      unless item
        stack.pop while !stack.empty? && stack.last[0] >= indent
        next
      end

      stack.pop while !stack.empty? && stack.last[0] > indent
      if !stack.empty? && stack.last[0] == indent
        stack.last[1] += 1
      else
        stack << [indent, 1]
      end
      stack.last[1] = item[4].to_i if item[4]
      counter = item[2][/\A(\d+)[.)]\z/, 1]
      next if counter.nil? || item[4] || counter.to_i == stack.last[1]

      findings << Finding.new(
        line: i + 1, checker: 'item-number',
        message: "Bullet counter \"#{item[2]}#{item[3]}\" is not the same with item position #{stack.last[1]}.  " \
                 "Consider adding manual [@#{counter}] counter."
      )
    end
  end

  def links(lines, in_block, dir, findings)
    text = lines.join("\n")
    lines.each_with_index do |line, i|
      next if in_block[i]

      line.to_enum(:scan, LINK).map { Regexp.last_match }.each do |match|
        target = match[1]
        if line[match.end(0)] == ']'
          findings << Finding.new(line: i + 1, checker: 'trailing-bracket-after-link',
                                  message: "Trailing ']' after link end")
        end
        finding = link_target_finding(target, text, dir)
        findings << Finding.new(line: i + 1, checker: finding[0], message: finding[1]) if finding
      end
    end
  end

  # [checker, message] when a link's target cannot be found, else nil.
  def link_target_finding(target, text, dir)
    if target.start_with?('#')
      id = target[1..]
      return nil if text.match?(/^[ \t]*:CUSTOM_ID:[ \t]+#{Regexp.escape(id)}[ \t]*$/i)

      ['invalid-custom-id-link', "Unknown custom ID \"#{id}\""]
    elsif target.start_with?('file:') || target.start_with?('./') || target.start_with?('../') ||
          target.start_with?('/') || target.start_with?('~/')
      file = target.sub(/\Afile:/, '').sub(/::.*\z/, '')
      full = file.start_with?('~/') ? File.expand_path(file) : File.expand_path(file, dir)
      File.exist?(full) ? nil : ['link-to-local-file', "Link to non-existent local file \"#{file}\""]
    elsif target.match?(/\A[A-Za-z][\w+.-]*:/) || target.start_with?('(') || target.start_with?('*')
      nil
    else
      found = text.include?("<<#{target}>>") ||
              text.match?(/^[ \t]*#\+NAME:[ \t]+#{Regexp.escape(target)}[ \t]*$/i) ||
              text.match?(/^\*+[ \t]+#{Regexp.escape(target)}[ \t]*$/)
      found ? nil : ['invalid-fuzzy-link', "Unknown fuzzy location \"#{target}\""]
    end
  end

  def footnotes(lines, in_block, findings)
    definitions = {}
    references = {}
    lines.each_with_index do |line, i|
      next if in_block[i]

      definition = line[/\A\[fn:([-\w]+)\]/, 1]
      definitions[definition] ||= i + 1 if definition
      body = definition ? line.sub(/\A\[fn:[-\w]+\]/, '') : line
      body.scan(/\[fn:([-\w]+)\]/) { |(label)| (references[label] ||= []) << (i + 1) }
    end
    references.each do |label, at|
      next if definitions.key?(label)

      at.each do |line|
        findings << Finding.new(line: line, checker: 'undefined-footnote-reference',
                                message: "Missing definition for footnote [#{label}]")
      end
    end
    definitions.each do |label, line|
      next if references.key?(label)

      findings << Finding.new(line: line, checker: 'unreferenced-footnote-definition',
                              message: "No reference for footnote definition [#{label}]")
    end
  end

  def timestamps(lines, in_block, findings)
    lines.each_with_index do |line, i|
      next if in_block[i]

      line.to_enum(:scan, TIMESTAMP).map { Regexp.last_match }.each do |match|
        next if valid_time?(match[1].to_i, match[2].to_i, match[3].to_i, match[4], match[5])

        findings << Finding.new(line: i + 1, checker: 'timestamp-syntax',
                                message: "Potentially malformed timestamp #{match[0]}")
      end
    end
  end

  def valid_time?(year, month, day, hour, minute)
    return false unless month.between?(1, 12) && day.between?(1, DAYS_IN_MONTH[month - 1])
    return false if month == 2 && day == 29 && !(((year % 4).zero? && !(year % 100).zero?) || (year % 400).zero?)

    hour.nil? || (hour.to_i.between?(0, 23) && minute.to_i.between?(0, 59))
  end
end
