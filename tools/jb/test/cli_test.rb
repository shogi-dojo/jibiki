# frozen_string_literal: true

require_relative '../jb'

code, out, = JB::Check.run('version')
JB::Check.equal('version exits 0', 0, code)
JB::Check.equal('version prints the version', "jb #{JB::VERSION}\n", out)

code, out, = JB::Check.run
JB::Check.equal('no command prints usage', 0, code)
JB::Check.includes('the overview lists the loop', out, 'jb check <path>...')
JB::Check.includes('the overview explains exit codes', out, '3  no JMdict index')

code, _out, err = JB::Check.run('frobnicate')
JB::Check.equal('unknown command is a usage error', JB::EXIT_USAGE, code)
JB::Check.includes('unknown command is named', err, 'unknown command: frobnicate')

%w[validate doctor jmdict lint commit].each do |command|
  code, _out, err = JB::Check.run(command)
  JB::Check.equal("#{command} without arguments is a usage error", JB::EXIT_USAGE, code)
  JB::Check.includes("#{command} prints its usage", err, "usage: jb #{command}")
end

%w[check validate doctor lint commit checkpoint jmdict version help].each do |command|
  code, out, = JB::Check.run('help', command)
  JB::Check.equal("help #{command} exits 0", 0, code)
  JB::Check.includes("help #{command} shows its usage", out, "usage: jb #{command}")
end

code, out, = JB::Check.run('check', '--help')
JB::Check.equal('a command --help prints its help', [0, true], [code, out.include?('The per-batch gate.')])

code, _out, err = JB::Check.run('help', 'frobnicate')
JB::Check.equal('help for an unknown command is a usage error', [JB::EXIT_USAGE, true],
                [code, err.include?('no such command: frobnicate')])

code, _out, err = JB::Check.run('validate')
JB::Check.includes('a usage error points at the command help', err, 'see: jb help validate')
