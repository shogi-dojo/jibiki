# frozen_string_literal: true

module JB
  EXIT_OK = 0
  EXIT_USAGE = 1
  # The checks ran and found problems (the validator's and doctor's code).
  EXIT_FAILED = 2
  # JMdict is needed but `rake jmdict:index` has not been run.
  EXIT_NO_INDEX = 3

  class UsageError < StandardError; end
end
