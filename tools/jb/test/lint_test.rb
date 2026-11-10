# frozen_string_literal: true

require 'fileutils'
require 'tmpdir'
require_relative '../jb'

good = JB::Check::AO

code, out, = JB::Check.run('lint', good)
JB::Check.equal('a corpus entry is clean', [0, ''], [code, out])

Dir.mktmpdir do |directory|
  bad = File.join(directory, 'bad.org')
  lines = File.read(good, encoding: 'UTF-8').split("\n")
  lines.delete_at(lines.index(':END:'))
  lines.push('1. one', '3. three', '[[nowhere]]')
  File.write(bad, lines.join("\n"))

  code, out, = JB::Check.run('lint', bad)
  JB::Check.equal('a broken entry fails', JB::EXIT_FAILED, code)
  JB::Check.equal('findings name the checkers in line order',
                  %w[incomplete-drawer item-number item-number invalid-fuzzy-link],
                  out.lines.map { |line| line.split(': ')[1] })

  code, out, = JB::Check.run('lint', '--json', bad, File.join(directory, 'missing.org'))
  JB::Check.equal('json mode fails too', JB::EXIT_FAILED, code)
  JB::Check.includes('json reports a missing file', out, '"exists": false')
end

code, _out, err = JB::Check.run('lint')
JB::Check.equal('lint without arguments is a usage error', [JB::EXIT_USAGE, true],
                [code, err.include?('usage: jb lint')])
