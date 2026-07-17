# frozen_string_literal: true

require 'json'
require 'optparse'
require 'pathname'
require 'fileutils'

module SourceCLI
  REPO_ROOT = File.expand_path('..', __dir__)
  JMDICT_PATH = ENV.fetch('JMDICT_PATH', File.join(REPO_ROOT, 'sources', 'jmdict', 'JMdict.xml.gz'))
  WARODAI_PATH = ENV.fetch('WARODAI_PATH', File.join(REPO_ROOT, 'sources', 'warodai'))
  N5_PATH = ENV.fetch('N5_PATH', File.join(REPO_ROOT, 'sources', 'jlpt-n5', 'wiktionary-n5.tsv'))

  module_function

  def common_parser(options, banner:)
    OptionParser.new do |parser|
      parser.banner = banner
      parser.on('--written TEXT', 'Exact Japanese written form') { |value| options[:written] = value }
      parser.on('--reading TEXT', 'Exact Japanese reading') { |value| options[:reading] = value }
      parser.on('--output PATH', 'Write pretty JSON to PATH instead of stdout') { |value| options[:output] = value }
      yield parser if block_given?
    end
  end

  def write_json(data, output = nil)
    json = "#{JSON.pretty_generate(data)}\n"
    if output
      path = File.expand_path(output, REPO_ROOT)
      FileUtils.mkdir_p(File.dirname(path))
      File.write(path, json, mode: 'w', encoding: Encoding::UTF_8)
      puts display_path(path)
    else
      puts json
    end
  end

  def relative_path(path)
    Pathname.new(path).relative_path_from(Pathname.new(REPO_ROOT)).to_s
  end

  def display_path(path)
    expanded = File.expand_path(path)
    return relative_path(expanded) if expanded.start_with?("#{REPO_ROOT}/")

    expanded
  end

  def ensure_exists!(*paths)
    missing = paths.reject { |path| File.exist?(path) }
    return if missing.empty?

    abort "Missing local source: #{missing.join(', ')}"
  end
end
