# frozen_string_literal: true

require 'stringio'

module JB
  # A minimal assertion helper for the print-and-diff tests in test/. Every
  # check prints one line, so `spin test` (which compares a compiled test's
  # stdout with CRuby's) catches any divergence, and bin/test.rb exits non-zero
  # when a check fails under CRuby. It lives here, not in test/, because
  # `spin test` builds every test/*.rb as a program of its own.
  module Check
    @failures = 0

    # The jibiki checkout the tests read corpus entries from.
    ROOT = File.expand_path('../../..', __dir__)
    AO = File.join(ROOT, 'entries', '1381', '1381380-ao.org')

    def self.failures
      @failures
    end

    def self.equal(label, expected, actual)
      if expected == actual
        puts "ok   #{label}"
      else
        @failures += 1
        puts "FAIL #{label}: expected #{expected.inspect}, got #{actual.inspect}"
      end
    end

    def self.includes(label, haystack, needle)
      equal(label, true, haystack.include?(needle))
    end

    # Runs the CLI in-process and answers [exit code, stdout, stderr].
    def self.run(*argv)
      out = StringIO.new
      err = StringIO.new
      code = CLI.main(argv, stdout: out, stderr: err)
      [code, out.string, err.string]
    end
  end
end
