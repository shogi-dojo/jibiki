# frozen_string_literal: true

require 'fileutils'
require 'json'
require 'tmpdir'
require_relative '../jb'

def add_entry(path)
  FileUtils.mkdir_p(File.dirname(path))
  File.write(path, "#+TITLE: x\n")
  JB::Git.run('add', path)
  JB::Git.run('commit', '--quiet', '-m', "feat: add #{path}")
  JB::Git.run('rev-parse', 'HEAD').strip
end

Dir.mktmpdir do |directory|
  Dir.chdir(directory) do
    JB::Git.run('init', '--quiet', '-b', 'main')
    JB::Git.run('config', 'user.name', 'jb test')
    JB::Git.run('config', 'user.email', 'jb@example.invalid')
    JB::Git.run('config', 'commit.gpgsign', 'false')
    File.write('PROGRESS.md', "# Progress\n\n## Older goal\n\nKept.\n")
    JB::Git.run('add', 'PROGRESS.md')
    JB::Git.run('commit', '--quiet', '-m', 'base')
    base = JB::Git.run('rev-parse', 'HEAD').strip

    rows = %w[a b c d].each_with_index.map do |name, i|
      { 'path' => "entries/#{i}/#{i}-#{name}.org", 'written' => name, 'reading' => name, 'jmdict_id' => i.to_s,
        'source_name' => 'Src', 'source_order' => (i + 1).to_s, 'source_url' => 'u', 'source_page_sha256' => 's',
        'source_guid' => "g#{i}", 'source_tags' => i.zero? ? "tab\there" : 'T' }
    end
    FileUtils.mkdir_p('tmp')
    File.write('tmp/t-sources.json', JSON.generate(rows))
    shas = rows.first(3).map { |row| add_entry(row['path']) }

    args = ['checkpoint', '--sources', 'tmp/t-sources.json', '--baseline', base, '--ledger', 'one.tsv',
            '--ledger', 'two.tsv', '--set-size', '2', '--batch-size', '1', '--set-names', 'First,Second',
            '--date', '2026-01-02']
    code, out, = JB::Check.run(*args)
    JB::Check.equal('checkpoint succeeds', 0, code)
    JB::Check.equal('progress line', "Progress checkpoint: 3/4 committed (75%). Next batch: 4.\n", out)

    one = File.read('one.tsv').split("\n")
    JB::Check.equal('ledger header', JB::Commands::Checkpoint::COLUMNS.join("\t"), one[0])
    JB::Check.equal('ledger rows carry their commit', [shas[0], shas[1]], one[1..].map { |l| l.split("\t")[7] })
    JB::Check.includes('a field with a tab is quoted', one[1], "\"tab\there\"")
    two = File.read('two.tsv').split("\n")
    JB::Check.equal('an uncommitted word has no commit yet', [shas[2], ''], two[1..].map { |l| l.split("\t", -1)[7] })

    progress = File.read('PROGRESS.md')
    JB::Check.includes('older sections are kept', progress, "## Older goal\n\nKept.\n")
    JB::Check.includes('a finished set says so', progress, '**2/2 committed; 0 remain.**')
    JB::Check.includes('finished set status', progress, 'All two batches are complete.')
    JB::Check.includes('a running set says where to continue', progress, '**1/2 committed; 1 remain.**')
    JB::Check.includes('running set status', progress, 'Continue with batch 2.')

    add_entry(rows[3]['path'])
    JB::Check.run(*args)
    progress = File.read('PROGRESS.md')
    JB::Check.equal('rerunning replaces the sections instead of appending', 1,
                    progress.scan('## Second 2-word vocabulary goal (2026-01-02)').length)
    state = JSON.parse(File.read('tmp/t-state.json'))
    JB::Check.equal('state file', { 'total_target' => 4, 'total_completed' => 4, 'total_remaining' => 0,
                                    'current_batch' => 5 }, state)

    add_entry('entries/9/9-stray.org')
    code, _out, err = JB::Check.run(*args)
    JB::Check.equal('an unexpected entry commit is refused', [JB::EXIT_FAILED, true],
                    [code, err.include?('do not add the first')])

    code, _out, err = JB::Check.run('checkpoint', '--sources', 'tmp/t-sources.json')
    JB::Check.equal('missing options are a usage error', [JB::EXIT_USAGE, true], [code, err.include?('usage:')])
  end
end
