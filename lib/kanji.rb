# frozen_string_literal: true

# The канджі part of the dictionary: one canonical Org record per character, keyed by codepoint.
# Source data (KANJIDIC2 readings, meanings, stroke count, grade, frequency) and Ukrainian
# translation blocks with stable IDs live in the same file.
require_relative 'kanji/record'
require_relative 'kanji/writer'
require_relative 'kanji/validator'
require_relative 'kanji/exporter'
require_relative 'kanji/importer'
