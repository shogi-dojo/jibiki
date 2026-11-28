#!/usr/bin/env ruby
# frozen_string_literal: true

# The whole word-addition loop without an agent in it: select → author each
# batch through one headless model call (Authoring::BatchAuthor, retries only
# for failing words) → render → jb check → one commit per word → checkpoint
# ledgers → Kanjium accents. Resumable: rerun the same command after a stop.
#
#   ruby scripts/author_cycle.rb --tag n10k-500ab --next 500
#
# --next N selects N words from the highest BCCWJ rank the ledgers record on;
# --min-rank/--limit pick the range by hand.
#
# The model defaults to Gemini 4 Hydrogen (high) through Antigravity; pick
# another with --provider/--model (scripts/acp_models.rb lists them).
#
# Everything lives in tmp/<tag>/: sources.json, batch-NN.json payloads, the
# prompt and reply of every call, usage.tsv (one row per call),
# reading-flags.jsonl (analyzer disagreements to review) and state.json.

require 'date'
require 'fileutils'
require 'json'
require 'optparse'
require 'rbconfig'
require_relative '../lib/acp_client'
require_relative '../lib/bccwj_batch'
require_relative '../lib/dictionary_sources/jmdict'
require_relative '../lib/authoring/batch_author'
require_relative '../lib/authoring/set_names'

ROOT = File.expand_path('..', __dir__)
# The default model won docs/authoring-model-benchmark.md: no retries, the
# fastest and among the cheapest runs, and the style the corpus is written in.
DEFAULT_MODEL = { provider: 'antigravity', model: 'gemini-4-hydrogen', effort: 'high' }.freeze
options = {
  batch_size: 25, max_retries: 2, timeout: 1800, data_root: ROOT, date: Date.today.iso8601,
  commit: true, checkpoint: true, provider: DEFAULT_MODEL[:provider]
}
OptionParser.new do |cli|
  cli.banner = 'Usage: author_cycle.rb --tag TAG (--next N | --sources FILE | --min-rank N --limit N) [options]'
  cli.on('--tag TAG', 'Work directory name under tmp/') { |v| options[:tag] = v }
  cli.on('--next N', Integer, 'Selection: N words, continuing from the last rank in the ledgers') { |v| options[:next] = v }
  cli.on('--sources FILE', 'Use an existing selection instead of selecting') { |v| options[:sources] = v }
  cli.on('--min-rank N', Integer, 'Selection: minimum BCCWJ rank') { |v| options[:min_rank] = v }
  cli.on('--limit N', Integer, 'Selection: number of words') { |v| options[:limit] = v }
  cli.on('--provider NAME', "antigravity | claude | codex (default: #{options[:provider]})") { |v| options[:provider] = v }
  cli.on('--model ID', "Model id as scripts/acp_models.rb lists it (default: #{DEFAULT_MODEL[:model]})") { |v| options[:model] = v }
  cli.on('--effort LEVEL', 'Reasoning effort (thought_level option)') { |v| options[:effort] = v }
  cli.on('--home DIR', 'Account config dir (CLAUDE_CONFIG_DIR / CODEX_HOME)') { |v| options[:home] = v }
  cli.on('--batch-size N', Integer, "Words per model call (default: #{options[:batch_size]})") { |v| options[:batch_size] = v }
  cli.on('--batches N', Integer, 'Stop after N batches (trial runs)') { |v| options[:batches] = v }
  cli.on('--max-retries N', Integer, "Retries for failing words (default: #{options[:max_retries]})") { |v| options[:max_retries] = v }
  cli.on('--timeout SEC', Integer, "Per call (default: #{options[:timeout]})") { |v| options[:timeout] = v }
  cli.on('--replay', 'Reuse saved replies in tmp/<tag>/ instead of calling the model') { options[:replay] = true }
  cli.on('--no-commit', 'Render into tmp/<tag>/entries and check only; no commits') { options[:commit] = false }
  cli.on('--no-checkpoint', 'Skip ledgers, PROGRESS.md and accents at the end') { options[:checkpoint] = false }
  cli.on('--date YYYY-MM-DD', 'CREATED_AT and ledger date (default: today)') { |v| options[:date] = v }
  cli.on('--data-root DIR', 'Checkout holding sources/ and tmp/ caches (default: this repo)') { |v| options[:data_root] = File.expand_path(v) }
end.parse!
abort 'Provide --tag.' unless options[:tag]
if options[:provider] == DEFAULT_MODEL[:provider] && options[:model].nil?
  options[:model] = DEFAULT_MODEL[:model]
  options[:effort] ||= DEFAULT_MODEL[:effort]
end

Dir.chdir(ROOT)
if options[:next]
  options[:min_rank] ||= Authoring::SetNames.last_bccwj_rank || abort('No BCCWJ ledger found; use --min-rank.')
  options[:limit] ||= options[:next]
end
work = File.join('tmp', options[:tag])
FileUtils.mkdir_p(work)
data = ->(path) { File.join(options[:data_root], path) }
ENV['JIBIKI_CACHE_DIR'] ||= data.('tmp/cache')
ENV['JMDICT_PATH'] ||= data.(BccwjBatch::DEFAULT_JMDICT_PATH)

def run!(*cmd)
  system(*cmd) || abort("failed: #{cmd.join(' ')}")
end

def jb_command
  return [ENV['JB']] if ENV['JB'].to_s != ''

  native = File.join(ROOT, 'tools/jb/build/bin/jb')
  File.executable?(native) ? [native] : [RbConfig.ruby, File.join(ROOT, 'tools/jb/bin/jb.rb')]
end

# --- selection -------------------------------------------------------------
sources_path = options[:sources] || File.join(work, 'sources.json')
baseline_path = File.join(work, 'baseline')
File.write(baseline_path, `git rev-parse HEAD`) if options[:commit] && !File.exist?(baseline_path)
unless File.exist?(sources_path)
  abort 'Provide --next, --sources or --min-rank and --limit.' unless options[:min_rank] && options[:limit]
  run!(RbConfig.ruby, 'scripts/select_bccwj.rb', '--min-rank', options[:min_rank].to_s, '--limit', options[:limit].to_s,
       '--bccwj', data.(BccwjBatch::DEFAULT_BCCWJ_PATH), '--jmdict-cache', data.(BccwjBatch::DEFAULT_JMDICT_CACHE),
       '--warodai-cache', data.(BccwjBatch::DEFAULT_WARODAI_CACHE), '--output', sources_path)
end
sources = JSON.parse(File.read(sources_path, encoding: 'UTF-8'))
unless options[:commit]
  # Trial runs render beside the work files, never into entries/.
  sources.each { |row| row['path'] = File.join(work, row['path']) }
end

sha_path = File.join(work, 'sha256')
unless File.exist?(sha_path)
  File.write(sha_path, DictionarySources::Jmdict.new(data.(BccwjBatch::DEFAULT_JMDICT_PATH)).archive_sha256)
end
renderer = BccwjBatch::Renderer.new(sources:, sha256: File.read(sha_path).strip, created_at: options[:date])

# --- model -----------------------------------------------------------------
call_log = Hash.new(0)
llm = lambda do |batch|
  lambda do |system:, user:|
    attempt = (call_log[batch] += 1)
    stem = File.join(work, format('reply-%02d-%d', batch, attempt))
    File.write("#{stem}.prompt.txt", "#{system}\n---\n#{user}")
    if options[:replay]
      abort "no saved reply #{stem}.txt to replay" unless File.exist?("#{stem}.txt")
      next AcpClient::Result.new(text: File.read("#{stem}.txt", encoding: 'UTF-8'), seconds: 0)
    end

    client = AcpClient.new(provider: options[:provider], model: options[:model], effort: options[:effort],
                           home: options[:home], timeout: options[:timeout])
    client.prompt(system:, user:).tap { |result| File.write("#{stem}.txt", result.text) }
  end
end
analyzer = system('which mecab > /dev/null 2>&1') ? Authoring::Reading::Mecab.new : nil

usage_path = File.join(work, 'usage.tsv')
unless File.exist?(usage_path)
  File.write(usage_path, "batch\tattempt\tprovider\tmodel\twords\tfailed\tseconds\tchars_in\tchars_out\t" \
                         "input_tokens\toutput_tokens\tcached_read\tcost_usd\ttool_calls\n")
end
log_attempts = lambda do |batch, attempts|
  File.open(usage_path, 'a') do |f|
    attempts.each_with_index do |a, i|
      usage = a.usage || {}
      cost = a.usage_update&.dig('cost', 'amount')
      f.puts [batch, i + 1, options[:provider], options[:model] || 'default', a.items, a.failed, a.seconds,
              a.chars_in, a.chars_out, usage['inputTokens'], usage['outputTokens'], usage['cachedReadTokens'],
              cost&.round(5), a.tool_calls].join("\t")
    end
  end
end

# --- batches ---------------------------------------------------------------
state_path = File.join(work, 'state.json')
state = File.exist?(state_path) ? JSON.parse(File.read(state_path)) : { 'done' => [] }
batches = sources.each_slice(options[:batch_size]).to_a

batches.each_with_index do |rows, idx|
  batch = idx + 1
  next if state['done'].include?(batch)
  break if options[:batches] && batch > options[:batches]

  payload_path = File.join(work, format('batch-%02d.json', batch))
  payload = File.exist?(payload_path) ? JSON.parse(File.read(payload_path, encoding: 'UTF-8')) : {}
  wanted = rows.each_with_index.to_h { |row, i| [(i + 1).to_s, row] }.reject { |n, _| payload.key?(n) }

  unless wanted.empty?
    author = Authoring::BatchAuthor.new(llm: llm.(batch), renderer:, max_retries: options[:max_retries], analyzer:)
    outcome = author.author(wanted)
    log_attempts.(batch, outcome.attempts)
    payload = payload.merge(outcome.payload).sort_by { |n, _| n.to_i }.to_h
    File.write(payload_path, JSON.pretty_generate(payload))
    File.open(File.join(work, 'reading-flags.jsonl'), 'a') do |f|
      outcome.reading_flags.each { |flag| f.puts(flag.merge('batch' => batch).to_json) }
    end
    unless outcome.failures.empty?
      File.write(File.join(work, format('failures-%02d.json', batch)), JSON.pretty_generate(outcome.failures))
      abort "batch #{batch}: #{outcome.failures.size} word(s) still failing after retries " \
            "(#{outcome.failures.keys.join(', ')}); see #{work}/failures-#{format('%02d', batch)}.json, " \
            "fix #{payload_path} by hand or rerun to retry"
    end
  end

  paths = rows.each_with_index.map { |row, i| renderer.render_item(row:, data: payload.fetch((i + 1).to_s)) }
  run!(*jb_command, 'check', '--yanagi', '--emacs', *paths)
  run!(*jb_command, 'commit', *paths) if options[:commit]
  state['done'] << batch
  File.write(state_path, JSON.pretty_generate(state))
  puts "batch #{batch}/#{batches.size}: #{rows.size} words #{options[:commit] ? 'committed' : 'checked'}"
end

finished = state['done'].size == batches.size
exit 0 unless finished && options[:commit] && options[:checkpoint] && !state['checkpointed']

# --- checkpoint and accents ------------------------------------------------
sets = (sources.size / 100.0).ceil
first = Authoring::SetNames.next_set_number
range = sets == 1 ? first.to_s : "#{first}-#{first + sets - 1}"
ledgers = Authoring::SetNames.ledger_paths(options[:date], sets)
names = (first...(first + sets)).map { |n| Authoring::SetNames.ordinal(n) }.join(',')
run!(*jb_command, 'checkpoint', '--sources', sources_path, '--baseline', baseline_path,
     *ledgers.flat_map { |l| ['--ledger', l] }, '--set-names', names, '--date', options[:date],
     '--batch-size', options[:batch_size].to_s)
run!('git', 'add', 'PROGRESS.md', *ledgers)
run!('git', 'commit', '-q', '-m', "docs: record sets #{range} vocabulary selection and commit ledgers")
run!(RbConfig.ruby, 'scripts/import_kanjium_accents.rb', '--accents', data.('sources/kanjium/accents.txt'))
unless `git status --porcelain entries`.strip.empty?
  run!('git', 'add', 'entries')
  run!('git', 'commit', '-q', '-m', "feat: import Kanjium pitch accents for sets #{range}")
end
state['checkpointed'] = true
File.write(state_path, JSON.pretty_generate(state))
puts "sets #{range} recorded"
