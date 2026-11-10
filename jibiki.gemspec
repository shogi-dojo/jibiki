# frozen_string_literal: true

require_relative 'lib/jibiki/version'

Gem::Specification.new do |spec|
  spec.name = 'jibiki'
  spec.version = Jibiki::VERSION
  spec.summary = 'Parser, exporter and patcher for the Japanese–Ukrainian Org dictionary'
  spec.description = 'Library code of the jibiki dictionary: parse Org entries, export them ' \
                     'to SQLite, and edit their Ukrainian layer line by line.'
  spec.authors = ['Shogi Dojo']
  spec.homepage = 'https://github.com/shogi-dojo/jibiki'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 4.0'

  spec.files = Dir['lib/**/*.rb'] + %w[LICENSE NOTICE]
  spec.require_paths = ['lib']

  spec.add_dependency 'csv'
  spec.add_dependency 'rexml'
  spec.add_dependency 'sequel', '~> 5.0'
  spec.add_dependency 'sqlite3', '~> 2.0'
  spec.add_dependency 'yanagi', '~> 0.3.2'
end
