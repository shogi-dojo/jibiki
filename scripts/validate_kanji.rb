#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../lib/kanji'

paths = ARGV.empty? ? Dir[File.expand_path('../kanji/U+*.org', __dir__)].sort : ARGV
problems = paths.flat_map do |path|
  record = Kanji::Record.load(path)
  Kanji::Validator.call(record, filename: path).map { |problem| "#{path}: #{problem}" }
rescue OrgEntry::ParseError => e
  ["#{path}: #{e.message}"]
end
abort problems.first(30).join("\n") unless problems.empty?
puts "Validated #{paths.size} kanji records"
