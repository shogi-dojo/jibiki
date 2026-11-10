# frozen_string_literal: true

require 'open3'

module JB
  # Runs git in the current directory and answers its stdout; a failing git
  # command raises Failed with git's own message.
  module Git
    module_function

    def run(*args)
      stdout, stderr, status = Open3.capture3('git', *args)
      raise Failed, "git #{args.first} failed: #{stderr.strip.empty? ? stdout.strip : stderr.strip}" unless status.success?

      stdout
    end
  end
end
