# frozen_string_literal: true

module Authoring
  # Set names as PROGRESS.md spells them ("One Hundred Eighty-fourth") and
  # the next free ledger paths (docs/n10k-next100-<date><letter>.tsv).
  module SetNames
    ONES = %w[Zero One Two Three Four Five Six Seven Eight Nine Ten Eleven Twelve Thirteen Fourteen Fifteen
              Sixteen Seventeen Eighteen Nineteen].freeze
    TENS = %w[_ _ Twenty Thirty Forty Fifty Sixty Seventy Eighty Ninety].freeze
    ORDINAL = { 'One' => 'First', 'Two' => 'Second', 'Three' => 'Third', 'Five' => 'Fifth', 'Eight' => 'Eighth',
                'Nine' => 'Ninth', 'Twelve' => 'Twelfth', 'Hundred' => 'Hundredth' }.freeze
    LEDGER_GLOB = 'docs/n10k-next100-*.tsv'

    module_function

    def cardinal(n)
      raise ArgumentError, "#{n} is out of range" unless (1..999).cover?(n)

      hundreds, rest = n.divmod(100)
      words = hundreds.zero? ? [] : ["#{ONES[hundreds]} Hundred"]
      if rest.positive?
        words << (rest < 20 ? ONES[rest] : [TENS[rest / 10], (ONES[rest % 10].downcase unless (rest % 10).zero?)].compact.join('-'))
      end
      words.join(' ')
    end

    def ordinal(n)
      words = cardinal(n)
      last = words[/[A-Za-z]+\z/]
      special = ORDINAL[last.capitalize]
      special = special.downcase if special && last == last.downcase
      replacement = special || (last.end_with?('y') ? "#{last.delete_suffix('y')}ieth" : "#{last}th")
      words.sub(/[A-Za-z]+\z/, replacement)
    end

    def next_set_number(root = '.') = Dir.glob(File.join(root, LEDGER_GLOB)).size + 1

    # count ledger paths for date, using letters not yet taken that day.
    def ledger_paths(date, count, root = '.')
      taken = Dir.glob(File.join(root, "docs/n10k-next100-#{date}?.tsv")).map { |p| p[/(.)\.tsv\z/, 1] }
      ('a'..'z').reject { |l| taken.include?(l) }.first(count).map { |l| "docs/n10k-next100-#{date}#{l}.tsv" }
    end
  end
end
