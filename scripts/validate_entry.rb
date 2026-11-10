#!/usr/bin/env ruby
# frozen_string_literal: true

# Validates entry files: ruby scripts/validate_entry.rb <path> [<path> ...]
# The checks live in lib/entry_validator.rb; including the module keeps the
# functions callable without a receiver for scripts and tests.
require_relative '../lib/entry_validator/archive_fallback'

include EntryValidator

if __FILE__ == $PROGRAM_NAME
  if ARGV.empty?
    puts "Usage: ruby validate_entry.rb <path_to_org_file> [<path_to_org_file> ...]"
    exit 1
  end

  preload_jmdict_entries(ARGV.filter_map do |path|
    next unless File.exist?(path)

    File.binread(path).force_encoding('UTF-8')[/^#\+JMDICT_ID: (.*)$/, 1]
  end)
  duplicate_errors = duplicate_jmdict_id_errors(ARGV)

  failed = false
  ARGV.each do |path|
    errors = validate_entry(path) + duplicate_errors[path]
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
