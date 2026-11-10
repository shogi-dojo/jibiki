# frozen_string_literal: true

require_relative '../entry_validator'
require_relative '../dictionary_sources/jmdict'

module EntryValidator
  # Answers JMdict entries straight from the gzipped archive: one
  # decompress-and-parse pass per preload, a few seconds a run. It is the
  # fallback for CRuby callers when `rake jmdict:index` has not been run.
  class ArchiveReader
    def initialize(path)
      @jmdict = DictionarySources::Jmdict.new(path)
      @entries = {}
    end

    def entry(ent_seq)
      key = ent_seq.to_s
      return @entries[key] if @entries.key?(key)

      @entries[key] = @jmdict.lookup(ent_seq: key).first
    end

    def preload(ent_seqs)
      missing = ent_seqs.map(&:to_s).reject { |seq| @entries.key?(seq) }
      return if missing.length < 2

      @jmdict.lookup_many(missing.map { |seq| { ent_seq: seq } }).each_with_index do |matches, index|
        @entries[missing[index]] = matches.first
      end
    end
  end

  ARCHIVE_READERS << ->(path) { ArchiveReader.new(path) } if ARCHIVE_READERS.empty?
end
