# frozen_string_literal: true

require 'digest'
require 'fileutils'

module DictionarySources
  # A precomputed digest of one JMdict archive: for every entry, each sense's
  # source fingerprint and gloss languages, which is all the validator and the
  # doctor read from JMdict. Looking an entry up costs a few seeks instead of
  # a decompress-and-parse pass over the whole 120 MB archive.
  #
  # The index is a text file in the cache directory named by the archive's
  # SHA-256, so a refreshed archive never reads a stale index:
  #
  #   # jibiki-jmdict-index 1 sha256=<archive sha>
  #   <ent_seq>\t<fingerprint> <lang>,<lang>\t<fingerprint> <lang>...
  #
  # Lines are sorted by numeric ent_seq for a binary search. The index is built
  # by `rake jmdict:index` (Jmdict#write_index, CRuby); this reader needs only
  # stdlib so that it compiles under Spinel.
  class JmdictIndex
    HEADER = 'jibiki-jmdict-index 1'

    attr_reader :path, :sha256

    def self.cache_root
      ENV.fetch('JIBIKI_CACHE_DIR', File.expand_path('../../tmp/cache', __dir__))
    end

    def self.index_path(sha256, cache_root = self.cache_root)
      File.join(cache_root, "jmdict-#{sha256}.tsv")
    end

    def self.stamp_path(archive_path, cache_root = self.cache_root)
      key = Digest::SHA256.hexdigest(File.expand_path(archive_path))[0, 16]
      File.join(cache_root, "jmdict-stamp-#{key}.tsv")
    end

    # The archive's SHA-256. Hashing 22 MB on every run is avoided with a stamp
    # recording the path, size and mtime it was last hashed at.
    def self.archive_sha256(archive_path, cache_root = self.cache_root)
      full = File.expand_path(archive_path)
      stat = File.stat(full)
      stamp = stamp_path(full, cache_root)
      if File.exist?(stamp)
        fields = File.read(stamp).chomp.split("\t")
        return fields[3] if fields.length == 4 && fields[0] == full && fields[1] == stat.size.to_s &&
                            fields[2] == stat.mtime.to_i.to_s
      end

      sha = Digest::SHA256.file(full).hexdigest
      write_stamp(stamp, [full, stat.size.to_s, stat.mtime.to_i.to_s, sha].join("\t"))
      sha
    end

    # A cache that cannot be written only costs the next run a re-hash.
    def self.write_stamp(stamp, line)
      FileUtils.mkdir_p(File.dirname(stamp))
      File.write(stamp, "#{line}\n")
    rescue SystemCallError
      nil
    end

    # The index for this archive, or nil when the archive is missing or its
    # index has not been built.
    def self.open(archive_path, cache_root = self.cache_root)
      return nil unless File.exist?(archive_path)

      sha = archive_sha256(archive_path, cache_root)
      path = index_path(sha, cache_root)
      File.exist?(path) ? new(path, sha) : nil
    end

    # One index line for an entry as Jmdict#parse_entry returns it.
    def self.line_for(entry)
      senses = entry[:senses].map do |sense|
        langs = sense[:glosses].map { |gloss| gloss[:lang] }.uniq
        langs.empty? ? sense[:source_fingerprint] : "#{sense[:source_fingerprint]} #{langs.join(',')}"
      end
      [entry[:ent_seq], *senses].join("\t")
    end

    def initialize(path, sha256)
      @path = path
      @sha256 = sha256
      File.open(path, 'rb') do |io|
        header = io.gets.to_s
        raise ArgumentError, "#{path} is not a #{HEADER} file" unless header.start_with?("# #{HEADER} ")

        @data_start = io.pos
      end
      @size = File.size(path)
    end

    # The entry with this ent_seq, shaped like the parts of
    # Jmdict#parse_entry the validator and doctor read, or nil. Nothing is
    # memoised: a lookup is a few seeks, and a corpus-wide run must not keep
    # every entry it has seen alive.
    def entry(ent_seq)
      line = find_line(ent_seq.to_s.to_i)
      line ? parse_line(line) : nil
    end

    private

    def parse_line(line)
      fields = line.chomp.split("\t")
      senses = []
      fields.drop(1).each_with_index do |field, index|
        fingerprint, langs = field.split(' ', 2)
        glosses = langs.to_s.split(',').map { |lang| { lang: lang } }
        senses << { index: index + 1, source_fingerprint: fingerprint, glosses: glosses }
      end
      { ent_seq: fields[0], senses: senses }
    end

    # Binary search over byte offsets: the line for offset p is the first line
    # starting at or after p, so the ent_seq it holds grows with p.
    def find_line(target)
      File.open(@path, 'rb') do |io|
        lo = @data_start
        hi = @size
        while lo < hi
          mid = (lo + hi) / 2
          line = line_at(io, mid)
          if line.nil? || line.split("\t", 2)[0].to_i >= target
            hi = mid
          else
            lo = mid + 1
          end
        end
        line = line_at(io, lo)
        line && line.split("\t", 2)[0].to_i == target ? line : nil
      end
    end

    def line_at(io, offset)
      if offset <= @data_start
        io.seek(@data_start)
      else
        io.seek(offset - 1)
        io.gets
      end
      io.gets
    end
  end
end
