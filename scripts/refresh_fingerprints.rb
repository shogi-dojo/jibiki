#!/usr/bin/env ruby
# frozen_string_literal: true

# Re-derives :SOURCE_FINGERPRINT: for every sense from the JMdict archive on
# disk, and restamps #+JMDICT_SOURCE_SHA256: on the entries it touches.
#
# EDRDG edits senses in place, so an entry that was reconciled months ago can
# start failing entries:validate without anyone having touched it. Refreshing
# those fingerprints by hand from a CI log (6cda91a did it for nigai and
# tateru) is slow and easy to get wrong, and it hides how much of the corpus
# actually moved. This does the same job against a known archive and reports
# the drift, so a JMdict bump lands as one reviewable commit.
#
# Only the fingerprint and the archive-hash header are rewritten. Everything
# derived from the sense — parts of speech, glosses, language sources — is left
# alone: this reports that they may be stale, it does not pretend to reconcile
# them.

require 'optparse'
require_relative '../lib/dictionary_sources/jmdict'
require_relative 'source_cli'

SENSE_HEADING = /^\* Sense (s-\d+-\d{3})$/.freeze
SOURCE_SENSE_INDEX = /^:SOURCE_SENSE_INDEX: (\d+)$/.freeze
SOURCE_FINGERPRINT = /^:SOURCE_FINGERPRINT:(?: (\h{64}))?$/.freeze
ARCHIVE_SHA256 = /^#\+JMDICT_SOURCE_SHA256: (\h{64})$/.freeze

Change = Struct.new(:path, :sense_id, :from, :to, keyword_init: true) do
  def added? = from.nil?
end

# Rewrites one entry's fingerprints in place. Returns the changes it made, or
# nil when the entry could not be resolved in the archive at all.
def refresh_entry(path, source_entry, archive_sha256:)
  lines = File.binread(path).force_encoding('UTF-8').split("\n", -1)
  changes = []
  sense_id = nil
  sense_index = nil

  lines.each_with_index do |line, index|
    if (match = SENSE_HEADING.match(line))
      sense_id = match[1]
      sense_index = nil
      next
    end
    next unless sense_id

    if (match = SOURCE_SENSE_INDEX.match(line))
      sense_index = match[1].to_i
      next
    end

    match = SOURCE_FINGERPRINT.match(line)
    next unless match && sense_index

    current = match[1]
    source_sense = source_entry[:senses][sense_index - 1]
    # A sense index that no longer resolves means JMdict dropped or reordered
    # senses, which needs a person: leave it for entries:validate to report.
    next if source_sense.nil?

    expected = source_sense[:source_fingerprint]
    next if current == expected

    lines[index] = ":SOURCE_FINGERPRINT: #{expected}"
    changes << Change.new(path:, sense_id:, from: current, to: expected)
  end

  return [] if changes.empty?

  lines.each_with_index do |line, index|
    next unless ARCHIVE_SHA256.match?(line)

    lines[index] = "#+JMDICT_SOURCE_SHA256: #{archive_sha256}"
    break
  end

  File.write(path, lines.join("\n"), encoding: Encoding::UTF_8)
  changes
end

def entry_paths(args)
  return args unless args.empty?

  Dir[File.join(SourceCLI::REPO_ROOT, 'entries', '*', '*.org')].sort
end

if __FILE__ == $PROGRAM_NAME
  options = {}
  OptionParser.new do |parser|
    parser.banner = 'Usage: refresh_fingerprints.rb [options] [<entry.org> ...]'
    parser.on('--check', 'Report drift and exit non-zero without writing') { options[:check] = true }
  end.parse!

  SourceCLI.ensure_exists!(SourceCLI::JMDICT_PATH)
  jmdict = DictionarySources::Jmdict.new(SourceCLI::JMDICT_PATH)
  archive_sha256 = jmdict.archive_sha256

  paths = entry_paths(ARGV)
  abort 'No entries found.' if paths.empty?

  ent_seqs = paths.to_h do |path|
    [path, File.binread(path).force_encoding('UTF-8')[/^#\+JMDICT_ID: (\d+)$/, 1]]
  end

  puts "Reading #{paths.length} entries against #{SourceCLI.relative_path(SourceCLI::JMDICT_PATH)} (#{archive_sha256[0, 12]}…)"
  matches = jmdict.lookup_many(ent_seqs.values.compact.uniq.map { |seq| { ent_seq: seq } })
  by_ent_seq = ent_seqs.values.compact.uniq.zip(matches.map(&:first)).to_h

  changes = []
  unresolved = []
  originals = {}

  paths.each do |path|
    source_entry = by_ent_seq[ent_seqs[path]]
    if source_entry.nil?
      unresolved << path
      next
    end

    originals[path] = File.binread(path) if options[:check]
    changes.concat(refresh_entry(path, source_entry, archive_sha256:))
  end

  # --check must not leave the tree dirty; restoring is simpler and less
  # error-prone than threading a dry-run flag through the rewrite itself.
  originals.each { |path, bytes| File.binwrite(path, bytes) } if options[:check]

  unresolved.each { |path| warn "Not found in archive, left untouched: #{SourceCLI.relative_path(path)}" }

  if changes.empty?
    puts 'All fingerprints already agree with the archive.'
    exit unresolved.empty? ? 0 : 1
  end

  touched = changes.map(&:path).uniq
  puts "#{changes.length} fingerprint(s) drifted across #{touched.length} entr#{touched.length == 1 ? 'y' : 'ies'}:"
  changes.each do |change|
    origin = change.added? ? '(none)' : "#{change.from[0, 12]}…"
    puts "  #{SourceCLI.relative_path(change.path)} #{change.sense_id}: #{origin} -> #{change.to[0, 12]}…"
  end
  puts
  puts 'Derived sections (parts of speech, glosses, language sources) are NOT updated;'
  puts 'review the entries above against JMdict before committing.'

  exit(options[:check] || !unresolved.empty? ? 1 : 0)
end
