# frozen_string_literal: true

require 'fileutils'
require 'tmpdir'
require_relative '../jb'

good = JB::Check::AO

code, out, = JB::Check.run('check', good)
JB::Check.equal('a corpus entry passes every step', 0, code)
JB::Check.equal('one summary line per step', %w[validate doctor lint], out.lines.map { |line| line.split.first })
JB::Check.equal('no failure sections when clean', false, out.include?('---'))

Dir.mktmpdir do |directory|
  bad = File.join(directory, '1381', '1381380-ao.org')
  FileUtils.mkdir_p(File.dirname(bad))
  lines = File.read(good, encoding: 'UTF-8').split("\n")
  lines.delete_at(lines.index(':END:'))
  File.write(bad, "#{lines.join("\n")}\n")

  code, out, = JB::Check.run('check', bad)
  JB::Check.equal('a broken entry fails the gate', JB::EXIT_FAILED, code)
  JB::Check.includes('the lint step fails', out, 'lint      FAIL')
  JB::Check.includes("the failing step's output follows", out, "--- lint\n#{bad}:")
  JB::Check.includes('an unparsable entry fails the doctor step', out, 'doctor    FAIL')
  JB::Check.includes('the parse error is reported', out, "unreadable: #{bad}: Line 19:")
end

code, _out, err = JB::Check.run('check', '--yanagi')
JB::Check.equal('check without paths is a usage error', [JB::EXIT_USAGE, true], [code, err.include?('usage: jb check')])
