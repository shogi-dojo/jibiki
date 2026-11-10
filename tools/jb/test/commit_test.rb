# frozen_string_literal: true

require 'fileutils'
require 'tmpdir'
require_relative '../jb'

def write_entry(path, title)
  FileUtils.mkdir_p(File.dirname(path))
  File.write(path, "#+TITLE: #{title}\n#+JMDICT_ID: 1\n")
end

Dir.mktmpdir do |directory|
  Dir.chdir(directory) do
    JB::Git.run('init', '--quiet', '-b', 'main')
    JB::Git.run('config', 'user.name', 'jb test')
    JB::Git.run('config', 'user.email', 'jb@example.invalid')
    JB::Git.run('config', 'commit.gpgsign', 'false')
    File.write('README', "base\n")
    JB::Git.run('add', 'README')
    JB::Git.run('commit', '--quiet', '-m', 'base')

    write_entry('entries/1/1-a.org', '青')
    write_entry('entries/2/2-b.org', '赤')

    code, out, = JB::Check.run('commit', '--dry-run', 'entries/1/1-a.org')
    JB::Check.equal('dry run plans the message', [0, "entries/1/1-a.org\tfeat: add 青 vocabulary entry\n"], [code, out])

    code, out, = JB::Check.run('commit', 'entries/1/1-a.org', 'entries/2/2-b.org')
    JB::Check.equal('commits succeed', 0, code)
    JB::Check.equal('prints one line per commit, oldest first',
                    ['feat: add 青 vocabulary entry', 'feat: add 赤 vocabulary entry'],
                    out.lines.map { |line| line.chomp.split(' ', 2)[1] })
    JB::Check.equal('each commit adds exactly its entry', "entries/2/2-b.org\n",
                    JB::Git.run('show', '--name-only', '--format=', 'HEAD'))

    write_entry('entries/3/3-c.org', '黄')
    File.write('README', "changed\n")
    JB::Git.run('add', 'README')
    code, _out, err = JB::Check.run('commit', 'entries/3/3-c.org')
    JB::Check.equal('refuses when something is already staged', [JB::EXIT_FAILED, true],
                    [code, err.include?('already staged: README')])

    code, _out, err = JB::Check.run('commit', '--template', 'add %s', 'entries/9/missing.org')
    JB::Check.equal('a missing entry fails', [JB::EXIT_FAILED, true], [code, err.include?('file does not exist')])
  end
end
