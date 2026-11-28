#!/usr/bin/env ruby
# frozen_string_literal: true

# Benchmarks authoring models on fixed word sets, with no commits:
#
#   ruby scripts/bench_models.rb prepare --from tmp/n10k-500z-sources.json   # set A (+ set B with --min-rank)
#   ruby scripts/bench_models.rb run --set A --provider claude --model sonnet --home ~/.claude-2
#   ruby scripts/bench_models.rb report               # metrics table, tmp/bench/report.md
#   ruby scripts/bench_models.rb compare --set A      # side by side with the corpus, tmp/bench/compare-A.md
#
# Set A: 20 words already in the corpus (varied: multi-sense, kana-only,
# verbs, adjectives), so every model can be read against the existing entry.
# Set B: the next 20 unselected words. Each run is one author_cycle call in
# tmp/bench-<set>-<provider>-<model>/.

require 'fileutils'
require 'json'
require 'optparse'
require 'rbconfig'
require_relative '../lib/org_entry'
require_relative '../lib/authoring/prompt'

ROOT = File.expand_path('..', __dir__)
BENCH = File.join(ROOT, 'tmp', 'bench')
Dir.chdir(ROOT)

command = ARGV.shift
options = { set: 'A', data_root: ROOT, size: 20 }
OptionParser.new do |cli|
  cli.on('--set NAME', 'A or B') { |v| options[:set] = v.upcase }
  cli.on('--from FILE', 'prepare: a past selection to draw set A from') { |v| options[:from] = v }
  cli.on('--min-rank N', Integer, 'prepare: also select set B from this BCCWJ rank') { |v| options[:min_rank] = v }
  cli.on('--size N', Integer, 'prepare: words per set (default 20)') { |v| options[:size] = v }
  cli.on('--provider NAME') { |v| options[:provider] = v }
  cli.on('--model ID') { |v| options[:model] = v }
  cli.on('--effort LEVEL') { |v| options[:effort] = v }
  cli.on('--home DIR') { |v| options[:home] = v }
  cli.on('--data-root DIR', 'Checkout holding sources/ and tmp/ caches') { |v| options[:data_root] = File.expand_path(v) }
end.parse!

def set_path(set) = File.join(BENCH, "set#{set}-sources.json")
def read_json(path) = JSON.parse(File.read(path, encoding: 'UTF-8'))
def slug(*parts) = parts.compact.join('-').gsub(/[^A-Za-z0-9.-]+/, '_')

def english_senses(row) = Authoring::Prompt.english_senses(row)
def pos(row) = english_senses(row).flat_map { |s| s['parts_of_speech'] }

# A spread of kinds, taken evenly across the source file.
def pick_varied(rows, size)
  kinds = {
    multi: ->(r) { english_senses(r).size >= 2 },
    kana: ->(r) { r['written'] !~ /\p{Han}/ },
    verb: ->(r) { pos(r).any? { |p| p.match?(/\Av[15kzt]|\Avs-i|\Avi\z|\Avt\z/) } },
    adjective: ->(r) { pos(r).any? { |p| p.match?(/\Aadj-(i|na)\z/) } }
  }
  quota = { multi: 5, kana: 3, verb: 4, adjective: 3 }
  chosen = []
  quota.each do |kind, n|
    matches = rows.select(&kinds[kind]) - chosen
    step = [matches.size / n, 1].max
    chosen.concat((0...n).filter_map { |i| matches[i * step] })
  end
  rest = rows - chosen
  step = [rest.size / [size - chosen.size, 1].max, 1].max
  chosen.concat((0...(size - chosen.size)).filter_map { |i| rest[i * step] })
  chosen.sort_by { |r| rows.index(r) }
end

def bench_dirs = Dir.glob(File.join(ROOT, 'tmp', 'bench-*')).select { |d| File.directory?(d) }.sort

def tsv(path)
  header, *rows = File.readlines(path, chomp: true).map { |l| l.split("\t", -1) }
  rows.map { |r| header.zip(r).to_h }
end

case command
when 'prepare'
  FileUtils.mkdir_p(BENCH)
  if options[:from]
    rows = pick_varied(read_json(options[:from]), options[:size])
    File.write(set_path('A'), JSON.generate(rows))
    puts "set A: #{rows.map { |r| r['written'] }.join(' ')}"
  end
  if options[:min_rank]
    data = ->(p) { File.join(options[:data_root], p) }
    system(RbConfig.ruby, 'scripts/select_bccwj.rb', '--min-rank', options[:min_rank].to_s, '--limit', options[:size].to_s,
           '--bccwj', data.('sources/bccwj/BCCWJ_frequencylist_luw2_ver1_0.zip'),
           '--jmdict-cache', data.('tmp/jmdict_cache.sqlite'), '--warodai-cache', data.('tmp/warodai_cache.sqlite'),
           '--output', set_path('B')) || abort('selection failed')
    puts "set B: #{read_json(set_path('B')).map { |r| r['written'] }.join(' ')}"
  end

when 'run'
  abort 'run needs --provider' unless options[:provider]
  tag = slug('bench', options[:set], options[:provider], options[:model] || 'default', options[:effort])
  args = ['--tag', tag, '--sources', set_path(options[:set]), '--no-commit', '--batch-size', options[:size].to_s,
          '--provider', options[:provider], '--data-root', options[:data_root]]
  { model: '--model', effort: '--effort', home: '--home' }.each { |k, flag| args += [flag, options[k]] if options[k] }
  exec(RbConfig.ruby, 'scripts/author_cycle.rb', *args)

when 'report'
  lines = ['| run | words | calls | first-try fails | still failing | seconds | in tok | out tok | cached | ' \
           'out tok/word | out chars/word | reading flags | cost $ |',
           '|---|---|---|---|---|---|---|---|---|---|---|---|---|']
  bench_dirs.each do |dir|
    usage_path = File.join(dir, 'usage.tsv')
    next unless File.exist?(usage_path)

    calls = tsv(usage_path)
    words = calls.first['words'].to_i
    sum = ->(k) { calls.sum { |c| c[k].to_f } }
    failing = Dir.glob(File.join(dir, 'failures-*.json')).sum { |f| read_json(f).size }
    flags = File.exist?(File.join(dir, 'reading-flags.jsonl')) ? File.readlines(File.join(dir, 'reading-flags.jsonl')).size : 0
    out_tokens = sum.('output_tokens')
    lines << [File.basename(dir).delete_prefix('bench-'), words, calls.size, calls.first['failed'], failing,
              sum.('seconds').round, sum.('input_tokens').to_i, out_tokens.to_i, sum.('cached_read').to_i,
              (out_tokens / words).round, (sum.('chars_out') / words).round, flags,
              sum.('cost_usd').positive? ? sum.('cost_usd').round(3) : ''].join(' | ').then { |l| "| #{l} |" }
  end
  File.write(File.join(BENCH, 'report.md'), "#{lines.join("\n")}\n")
  puts lines

when 'compare'
  rows = read_json(set_path(options[:set]))
  runs = bench_dirs.select { |d| File.basename(d).start_with?("bench-#{options[:set]}-") }
  payloads = runs.to_h do |dir|
    merged = Dir.glob(File.join(dir, 'batch-*.json')).sort.map { |f| read_json(f) }.reduce({}, :merge)
    [File.basename(dir).delete_prefix("bench-#{options[:set]}-"), merged]
  end
  out = +''
  rows.each_with_index do |row, idx|
    n = (idx + 1).to_s
    out << "\n## #{n}. #{row['written']}【#{row['reading']}】\n"
    english_senses(row).each_with_index do |s, i|
      out << "S#{i + 1}: #{s['glosses'].select { |g| g['lang'] == 'eng' }.map { |g| g['text'] }.join('; ')}\n"
    end
    if options[:set] == 'A' && File.exist?(row['path'])
      entry = OrgEntry.load(row['path'])
      out << "\n### corpus\n"
      entry.senses.each_with_index do |sense, i|
        gloss = sense.ukrainian_glosses.map(&:text).join(' / ')
        next if gloss.empty?

        out << "G#{i + 1} #{gloss} | #{sense.learner_notes.map(&:uk).join(' ')}\n"
        sense.examples.each { |ex| out << "E #{ex.ja} | #{ex.reading} | #{ex.uk}\n" }
      end
    end
    payloads.each do |name, payload|
      data = payload[n]
      out << "\n### #{name}\n"
      next out << "(missing)\n" unless data

      data['senses'].each_with_index { |(g, note), i| out << "G#{i + 1} #{g} | #{note}\n" }
      data['examples'].each { |ja, reading, uk, _| out << "E #{ja} | #{reading} | #{uk}\n" }
    end
  end
  path = File.join(BENCH, "compare-#{options[:set]}.md")
  File.write(path, out)
  puts "wrote #{path} (#{payloads.size} runs)"

else
  abort 'usage: bench_models.rb prepare|run|report|compare [options]'
end
