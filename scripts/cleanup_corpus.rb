#!/usr/bin/env ruby
# frozen_string_literal: true

require 'fileutils'
require_relative '../lib/org_entry'
require_relative '../lib/entry_doctor'

REPO_ROOT = File.expand_path('..', __dir__)
NOTES_DIR = File.join(REPO_ROOT, 'notes')
DOWNGRADES_MD = File.join(NOTES_DIR, 'profile-downgrades.md')

def resolve_reading_text(str)
  res = str.dup

  # 10 specific bad readings fixes:
  res.gsub!('でぱーとおくじょうであそぶ。', 'でぱーとのおくじょうであそぶ。')
  res.gsub!('なにかしつもんはありませんか。', 'なにかしつもんはありますか。')
  res.gsub!('このまちわくるまがおおいです。', 'このまちはくるまがおおいです。')
  res.gsub!('ちちはまいにちせびろをきてしごとへいきます。', 'ちちはまいにちせびろをきてしごとにいきます。')
  res.gsub!('らいねん の なつ に うみ え いきたい です。', 'らいねん の なつ に うみ へ いきたい です。')
  res.gsub!('かぞく と りょこう しま。', 'かぞく と りょこう します。')
  res.gsub!('わたしかぞくは、まいとしおしょうがつにしんせきのいえにあつまっておいわいをします。', 'わたしのかぞくは、まいとしおしょうがつにしんせきのいえにあつまっておいわいをします。')
  res.gsub!('へや に いす が むっつ ありました。', 'へや に いす が むっつ あります。')
  res.gsub!('この やさい は、 たね を うえて から やく 3 かげつ で しゅうかく できます。', 'この やさい は、 たね を うえて から やく さんかげつ で しゅうかく できます。')

  # Specific irregular / bare kanji lines:
  res.gsub!('日(に)本(ほん)に行(い)きたいです。でも、お(金)金(かね)がありません。', 'にほんにいきたいです。でも、おかねがありません。')
  res.gsub!('コーヒーのほかに何かのみますか。', 'こーひーのほかになにかのみますか。')
  res.gsub!('しゃちょうはなんと仰っていましたか。', 'しゃちょうはなんとおっしゃっていましたか。')
  res.gsub!('昨[きのう]日[日]、 友[とも]達[だち]を 見[み]ました。', 'きのう、 ともだちを みました。')
  res.gsub!('そのことばのいみを知りません。', 'そのことばのいみをしりません。')
  res.gsub!('今[きょう]日[日]は ３[みっ]日[か]です。', 'きょうは みっかです。')
  res.gsub!('つぎのやすみに何をしますか。', 'つぎのやすみになにをしますか。')
  res.gsub!('晩(ばん)ごは(飯)ができましたよ。', 'ばんごはんができましたよ。')
  res.gsub!('今[きょう]日[日]は ６[むい]日[か]です。', 'きょうは むいかです。')
  res.gsub!('６[むい]日[か] 間[かん] 旅[りょ]行[こう]します。', 'むいかかん りょこうします。')
  res.gsub!('八[はち]月[がつ] ６[むい]日[か]は 私[わたし]の 誕[たん]生[じょう]日[び]です。', 'はちがつ むいかは わたしの たんじょうびです。')
  res.gsub!('そのあかいすかーとはかのじょによくに合っている。', 'そのあかいすかーとはかのじょによくあっている。')
  res.gsub!('びょういんでペットけんさを受けました。', 'びょういんでぺっとけんさをうけました。')

  # Replace ruby notations
  res.gsub!(/\p{Han}+\[([^\]]+)\]/, '\1')
  res.gsub!(/\p{Han}+[\(（]([^\)）]+)[\)）]/, '\1')
  res.gsub!(/[0-9０-９]+\[([^\]]+)\]/, '\1')
  res.gsub!(/[0-9０-９]+[\(（]([^\)）]+)[\)）]/, '\1')

  # Clean any leftover brackets
  res.gsub!(/\[(.*?)\]/, '\1')
  res.gsub!(/[\(（]([^\)）]+)[\)）]/, '\1')

  # Normalize katakana in reading to hiragana if present
  # Note: Exporters::HouhouVocabMatcher.to_hiragana converts katakana to hiragana
  Exporters::HouhouVocabMatcher.to_hiragana(Exporters::HouhouVocabMatcher.nfkc(res))
end

def clean_file(path)
  content = File.read(path, encoding: Encoding::UTF_8)
  lines = content.split("\n", -1)
  lines.pop if content.end_with?("\n")

  new_lines = []
  i = 0
  while i < lines.length
    line = lines[i]

    # 1. Strip empty uk-s- gloss blocks
    if line =~ /^\*{3}\s+(uk-s-[^\s]+)/
      offset = 1
      body = []
      while lines[i + offset] && !lines[i + offset].start_with?('*')
        body << lines[i + offset]
        offset += 1
      end
      text_line = body.find { |b| b =~ /^- text ::/ }
      if text_line.nil? || text_line =~ /^- text ::\s*$/
        # Skip this entire empty block
        i += offset
        next
      end
    end

    # 2. Fix Cyrillic in FOCUS
    if line =~ /^- FOCUS :: (.*)$/
      foc = $1
      if foc.match?(/\p{Cyrillic}/)
        cleaned_foc = foc.sub(/\s*\([^\)]*\)/, '').strip
        line = "- FOCUS :: #{cleaned_foc}"
      end
    end

    # 3. Fix kanji / bad readings in READING
    if line =~ /^- READING :: (.*)$/
      rd = $1
      cleaned_rd = resolve_reading_text(rd)
      line = "- READING :: #{cleaned_rd}"
    end

    new_lines << line
    i += 1
  end

  new_content = new_lines.join("\n").strip + "\n"
  File.write(path, new_content, encoding: Encoding::UTF_8)
end

# Phase 1: Clean text across all files
paths = Dir[File.join(REPO_ROOT, 'entries', '*', '*.org')].sort
paths.each { |p| clean_file(p) }

# Phase 2: Re-derive QUALITY_PROFILE and ENTRY_STATUS headers
downgrades = []

paths.each do |path|
  entry = OrgEntry.load(path)
  current_prof = entry.quality_profile
  current_status = entry.entry_status

  eng_senses = entry.senses.select { |s| s.english_glosses.any? { |eg| eg.lang == 'eng' } }
  covered_senses = eng_senses.select { |s| s.ukrainian_glosses.any? { |ug| ug.text && !ug.text.strip.empty? } }
  all_uk_glosses = entry.senses.flat_map(&:ukrainian_glosses).select { |ug| ug.text && !ug.text.strip.empty? }

  primary_senses = entry.senses.select { |s| s.learner_priority == 'primary' }
  primary_learner_ready = primary_senses.all? do |s|
    has_note = s.learner_notes.any? { |n| n.uk && !n.uk.strip.empty? }
    levels = s.examples.map { |ex| ex.level || 'beginner' }
    has_graded_ex = levels.length >= 3 && levels.include?('beginner') &&
                    (levels.include?('intermediate') || levels.include?('neutral'))
    has_note && has_graded_ex
  end

  has_uncovered_eng = covered_senses.length < eng_senses.length
  meets_core = !has_uncovered_eng && !eng_senses.empty?
  meets_learner = meets_core && primary_learner_ready

  new_prof = current_prof
  new_status = current_status

  if all_uk_glosses.empty?
    new_status = 'untranslated'
    new_prof = 'core'
  elsif !meets_learner
    new_prof = 'core'
  end

  if new_prof != current_prof || new_status != current_status
    downgrades << {
      path: path.sub("#{REPO_ROOT}/", ''),
      jmdict_id: entry.jmdict_id,
      title: entry.title,
      romaji: entry.romaji,
      from_profile: current_prof,
      to_profile: new_prof,
      from_status: current_status,
      to_status: new_status,
      total_eng_senses: eng_senses.length,
      covered_eng_senses: covered_senses.length,
      primary_senses: primary_senses.length,
      primary_learner_ready: primary_learner_ready
    }

    content = File.read(path, encoding: Encoding::UTF_8)
    content.sub!(/^#\+QUALITY_PROFILE: .*$/, "#+QUALITY_PROFILE: #{new_prof}")
    content.sub!(/^#\+ENTRY_STATUS: .*$/, "#+ENTRY_STATUS: #{new_status}")
    File.write(path, content, encoding: Encoding::UTF_8)
  end
end

FileUtils.mkdir_p(NOTES_DIR)
md_content = <<~MD
  # Profile and Status Downgrades Audit Log

  Total adjusted entries: #{downgrades.length}

  | JMdict ID | Title | Romaji | From Profile | To Profile | Status | Covered / Total Senses | File |
  |---|---|---|---|---|---|---|---|
  #{downgrades.map do |d|
    "| #{d[:jmdict_id]} | #{d[:title]} | #{d[:romaji]} | #{d[:from_profile]} | **#{d[:to_profile]}** | #{d[:to_status]} | #{d[:covered_eng_senses]}/#{d[:total_eng_senses]} | [`#{d[:path]}`](file://#{File.join(REPO_ROOT, d[:path])}) |"
  end.join("\n")}
MD

File.write(DOWNGRADES_MD, md_content, encoding: Encoding::UTF_8)
puts "Cleanup complete. Processed #{paths.length} files. Recorded #{downgrades.length} downgrades to #{DOWNGRADES_MD}"
