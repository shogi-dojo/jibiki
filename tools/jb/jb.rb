# frozen_string_literal: true

# The package entry point. Every file is named by a literal require_relative:
# Spinel resolves requires at compile time and cannot glob, so a new file must
# be added here (or in jb/cli.rb) by name.
require_relative 'jb/cli'
require_relative 'jb/check'
