# frozen_string_literal: true

require 'fileutils'
require 'tmpdir'
require_relative '../jb'

good = JB::Check::AO

code, out, = JB::Check.run('validate', good)
JB::Check.equal('a corpus entry passes', 0, code)
JB::Check.equal('verdict and progress lines', ["Validating Org entry: #{good}", 'Looking up entry 1381380 in JMdict...',
                                               'Validation PASSED successfully!'], out.lines.map(&:chomp))

code, out, = JB::Check.run('validate', '--json', good, good)
JB::Check.equal('a duplicated path fails the batch', JB::EXIT_FAILED, code)
JB::Check.includes('the duplicate is reported', out, 'Duplicate JMDICT_ID 1381380 across files')

Dir.mktmpdir do |directory|
  bad = File.join(directory, '1381', '1381380-ao.org')
  FileUtils.mkdir_p(File.dirname(bad))
  text = File.read(good, encoding: 'UTF-8')
  File.write(bad, text.sub(/^:SOURCE_FINGERPRINT: \h+$/, ":SOURCE_FINGERPRINT: #{'0' * 64}").sub("\n* ", " \n* "))
  code, out, = JB::Check.run('validate', bad)
  JB::Check.equal('a broken entry fails', JB::EXIT_FAILED, code)
  JB::Check.includes('the fingerprint is checked against the index', out, 'Fingerprint mismatch for s-1381380-001')
  JB::Check.includes('the text checks run', out, 'has trailing whitespace')
end

code, out, = JB::Check.run('jmdict', '1381380', '42')
JB::Check.equal('jmdict fails when an id is missing', JB::EXIT_FAILED, code)
JB::Check.includes('jmdict prints the indexed senses', out, '"source_fingerprint"')
JB::Check.includes('jmdict marks the missing id', out, '"missing": true')
