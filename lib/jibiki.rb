# frozen_string_literal: true

# Entry point for using the dictionary tooling as a library (the jibiki gem):
# the Org entry parser, the line-level patcher, the validator and the rich
# SQLite exporter.
require_relative 'jibiki/version'
require_relative 'org_entry'
require_relative 'org_entry/patch'
require_relative 'entry_validator/archive_fallback'
require_relative 'exporters/rich_sqlite'
