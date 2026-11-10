# frozen_string_literal: true

require 'json'
require_relative '../jb'

good = JB::Check::AO

code, out, = JB::Check.run('doctor', '--json', '--with-jmdict', good)
report = JSON.parse(out)
JB::Check.equal('doctor exit code follows the errors', report['total_errors'].positive? ? 2 : 0, code)
JB::Check.equal('one entry analysed', 1, report['total_entries'])
JB::Check.equal('the report names the entry', 1_381_380, report['reports'].first['jmdict_id'])

code, out, = JB::Check.run('doctor', good)
JB::Check.includes('the human report has its banner', out, 'JIBIKI ENTRY DOCTOR REPORT')
JB::Check.equal('human and JSON agree on the exit code', report['total_errors'].positive? ? 2 : 0, code)
