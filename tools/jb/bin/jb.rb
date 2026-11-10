#!/usr/bin/env ruby
# frozen_string_literal: true

# The jb command. Runs from a checkout (`ruby tools/jb/bin/jb.rb ...`), and
# once built, as a Spinel binary (tools/jb/build/bin/jb).
require_relative '../jb'

exit JB::CLI.main(ARGV)
