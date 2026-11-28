# frozen_string_literal: true

module Authoring
  # Builds the compact authoring prompt. The static RULES block never varies
  # between batches (so providers can cache it); only the word lines change.
  # The model writes Ukrainian content only: everything else in an entry is
  # derived mechanically from JMdict.
  module Prompt
    NOTE_MAX_CHARS = 200
    WARODAI_MAX_CHARS = 150

    RULES = <<~RULES
      You write content for a Japanese–Ukrainian learner dictionary. Reply with the requested lines only: no prose, no Markdown, no code fences, no tools.

      For each word @N you get its English JMdict senses S1..Sk and an optional Russian Warodai excerpt (W:). Warodai is for disambiguation only: never copy or translate it.

      Reply per word, in this exact format (fields separated by "|", never use "|" inside a field):
      @N p=<number of the most common sense>
      G1|<Ukrainian gloss for S1>|<Ukrainian learner note for S1>
      ... one G line per sense, G1..Gk, none skipped ...
      E|<Japanese sentence>|<Ukrainian translation>|<focus>
      E|...
      E|...

      Glosses: original, idiomatic Ukrainian equivalents (synonyms separated by "; "), matching that sense only.
      Notes: 1–2 sentences, at most #{NOTE_MAX_CHARS} characters, adding something the gloss does not say (usage, register, typical collocation, nuance vs. near-synonyms). Never repeat the gloss.
      Examples: exactly 3, all for sense p, graded: 1) short and simple, 2) everyday sentence, 3) longer, more complex. Natural modern Japanese. The sentence must contain the word: <focus> is the word exactly as it appears in the sentence (an inflected form such as 食べた for 食べる); leave <focus> empty when the word appears unchanged.
      Ukrainian: natural modern Ukrainian, no Russianisms or calques; keep euphony (у/в, з/із/зі, і/й); straight apostrophe '. Avoid Japanese personal and place names; if one is unavoidable, transliterate it with the NJS system (ші, чі, джі, ґ, дз, шьо — never сі, ті, дзі, г).
    RULES

    READINGS_RULE = <<~RULE
      Also give each example's reading: append "|<reading>" to every E line, the whole sentence in hiragana with the same punctuation, kana in the sentence kept as they are (katakana written as hiragana).
    RULE

    module_function

    # rows: selection rows (see BccwjBatch::Selector) in batch order.
    # numbers: the item number for each row (defaults to 1..n).
    # errors: { number => [messages] } from a previous attempt, for retries.
    def build(rows, numbers: nil, errors: {}, readings: false)
      numbers ||= (1..rows.size).to_a
      user = +''
      unless errors.empty?
        user << "Your previous reply had problems. Rewrite only these words, fixing:\n"
        errors.sort_by { |n, _| n.to_i }.each do |n, messages|
          user << "@#{n}: #{messages.join('; ')}\n"
        end
        user << "\n"
      end
      rows.zip(numbers).each { |row, n| user << word_block(n, row) << "\n" }
      { system: readings ? "#{RULES}#{READINGS_RULE}" : RULES, user: }
    end

    def word_block(number, row)
      head = row['written'] == row['reading'] ? row['written'] : "#{row['written']}【#{row['reading']}】"
      lines = ["@#{number} #{head}"]
      english_senses(row).each_with_index do |sense, idx|
        tags = Array(sense['parts_of_speech']) + Array(sense['miscellaneous']) + Array(sense['fields'])
        glosses = sense['glosses'].select { |g| g['lang'] == 'eng' }.map { |g| g['text'] }.join('; ')
        lines << "S#{idx + 1}#{tags.empty? ? '' : " (#{tags.join(', ')})"} #{glosses}"
      end
      warodai = warodai_excerpt(row)
      lines << "W: #{warodai}" if warodai
      lines.join("\n")
    end

    def english_senses(row)
      row.fetch('entry').fetch('senses').select { |s| s['glosses'].any? { |g| g['lang'] == 'eng' } }
    end

    def warodai_excerpt(row)
      card = Array(row['warodai_cards']).first
      return nil unless card

      text = card['body'].to_s.gsub(/<[^>]+>/, '').gsub(/\s+/, ' ').strip
      return nil if text.empty?

      text.length > WARODAI_MAX_CHARS ? "#{text[0, WARODAI_MAX_CHARS]}…" : text
    end
  end
end
