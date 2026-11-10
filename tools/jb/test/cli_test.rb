# frozen_string_literal: true

require_relative '../jb'

code, out, = JB::Check.run('version')
JB::Check.equal('version exits 0', 0, code)
JB::Check.equal('version prints the version', "jb #{JB::VERSION}\n", out)

code, out, = JB::Check.run
JB::Check.equal('no command prints usage', 0, code)
JB::Check.includes('usage lists validate', out, 'validate [--json] <path>...')

code, _out, err = JB::Check.run('frobnicate')
JB::Check.equal('unknown command is a usage error', JB::EXIT_USAGE, code)
JB::Check.includes('unknown command is named', err, 'unknown command: frobnicate')

%w[validate doctor jmdict lint commit].each do |command|
  code, _out, err = JB::Check.run(command)
  JB::Check.equal("#{command} without arguments is a usage error", JB::EXIT_USAGE, code)
  JB::Check.includes("#{command} prints its usage", err, "usage: jb #{command}")
end
