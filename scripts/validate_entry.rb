#!/usr/bin/env ruby
# frozen_string_literal: true

# Validates entry files: ruby scripts/validate_entry.rb <path> [<path> ...]
# The checks live in lib/entry_validator.rb; including the module keeps the
# functions callable without a receiver for scripts and tests. The archive
# fallback answers JMdict lookups when `rake jmdict:index` has not been run.
require_relative '../lib/entry_validator/archive_fallback'

include EntryValidator

if __FILE__ == $PROGRAM_NAME
  if ARGV.empty?
    puts "Usage: ruby validate_entry.rb <path_to_org_file> [<path_to_org_file> ...]"
    exit 1
  end

  exit EntryValidator.run(ARGV)
end
