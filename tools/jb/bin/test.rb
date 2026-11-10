#!/usr/bin/env ruby
# frozen_string_literal: true

# Runs every test file in one CRuby program (`rake jb:test`, and the Minitest
# wrapper test/jb_cli_test.rb). `spin test` compiles and runs each test/*.rb
# separately and diffs it against CRuby: that is the parity gate.
#
# The requires are literal, not globbed: a compiled program can only load
# what it was compiled with.
require_relative '../test/cli_test'
require_relative '../test/validate_test'
require_relative '../test/doctor_test'
require_relative '../test/lint_test'
require_relative '../test/check_test'

exit(JB::Check.failures.zero? ? 0 : 1)
