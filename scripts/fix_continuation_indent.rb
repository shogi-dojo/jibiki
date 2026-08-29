#!/usr/bin/env ruby
# frozen_string_literal: true

# Indent wrapped continuation lines that were authored without indentation.
#
# docs/org-format.md: "Each list item is one paragraph. A parser joins wrapped
# physical continuation lines with a single space. A continuation line must be
# indented by two spaces."
#
# A batch of entries was authored with numbered sub-points and trailing
# sentences flush against column 0 inside `- UK ::` learner notes. The parser
# rejects those lines, which fails the corpus smoke test and aborts
# `rake export:rich`.
#
# This walks the same state machine as OrgEntry::Document.parse and indents
# only the lines that parser would raise on, and only when they directly
# continue a list item. Every other line is passed through untouched.
#
# Usage:
#   ruby scripts/fix_continuation_indent.rb --check   # report, change nothing
#   ruby scripts/fix_continuation_indent.rb           # apply

require 'optparse'

check_only = false
OptionParser.new do |opts|
  opts.banner = 'Usage: fix_continuation_indent.rb [--check]'
  opts.on('--check', 'Report offending lines without writing') { check_only = true }
end.parse!

REPO_ROOT = File.expand_path('..', __dir__)

# Returns [rewritten_lines, offending_line_numbers].
def repair(lines)
  inside_drawer = false
  after_list_item = false
  out = []
  offenders = []

  lines.each_with_index do |line, index|
    line_number = index + 1

    if line.start_with?('#+') || line.strip.empty? || line.start_with?('*')
      out << line
      after_list_item = false
      next
    end

    if line == ':PROPERTIES:'
      inside_drawer = true
      out << line
      next
    end

    if line == ':END:'
      inside_drawer = false
      after_list_item = false
      out << line
      next
    end

    if inside_drawer
      out << line
      next
    end

    if line.start_with?('- ')
      out << line
      after_list_item = true
      next
    end

    # Already a well-formed continuation.
    if line.start_with?('  ')
      out << line
      next
    end

    # The parser raises on anything else. When it directly continues a list
    # item it is a wrapped line missing its indentation; indent it. Otherwise
    # leave it alone so the parser still reports the real problem.
    if after_list_item
      out << "  #{line}"
      offenders << line_number
    else
      out << line
    end
  end

  [out, offenders]
end

paths = Dir.glob(File.join(REPO_ROOT, 'entries', '*', '*.org')).sort
changed = []

paths.each do |path|
  lines = File.readlines(path, chomp: true, encoding: 'UTF-8')
  repaired, offenders = repair(lines)
  next if offenders.empty?

  changed << [path, offenders]
  File.write(path, "#{repaired.join("\n")}\n", encoding: 'UTF-8') unless check_only
end

changed.each do |path, offenders|
  puts "#{path.sub("#{REPO_ROOT}/", '')}: lines #{offenders.join(', ')}"
end

verb = check_only ? 'would indent' : 'indented'
puts "#{changed.size} files, #{verb} #{changed.sum { |_, o| o.size }} lines"
