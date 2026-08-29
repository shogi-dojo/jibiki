source 'https://rubygems.org'

gem 'rake'
gem 'minitest'
gem 'sequel', '~> 5.0'
# force_ruby_platform: the precompiled native gems bundle a libsqlite3 built
# without FTS3/FTS4, which the Houhou overlay contract requires; building from
# source enables them.
gem 'sqlite3', '~> 2.0', force_ruby_platform: true
gem 'rexml'
gem 'csv'

# Japanese->Ukrainian transliteration policy engine, shared with the meijin
# repo. Pinned to a local path while the rules are validated against both real
# corpora; switch to a git source + tag before publishing.
gem 'yanagi', path: '../yanagi'
