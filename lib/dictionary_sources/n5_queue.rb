# frozen_string_literal: true

require 'csv'

module DictionarySources
  class N5Queue
    attr_reader :path

    def initialize(path)
      @path = File.expand_path(path)
    end

    def fetch(source_order)
      row = CSV.foreach(path, headers: true, col_sep: "\t", quote_char: '"').find do |candidate|
        candidate.fetch('source_order').to_i == source_order.to_i
      end
      raise KeyError, "N5 source_order #{source_order} was not found in #{path}" unless row

      row.to_h.transform_keys(&:to_sym)
    end
  end
end
