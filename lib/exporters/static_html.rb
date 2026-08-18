# frozen_string_literal: true

require 'fileutils'
require 'json'
require 'time'

module Exporters
  class StaticHtml
    MAX_RESULTS = 50

    class << self
      def export(entries, output_path, warodai:)
        ensure_unique_entries!(entries)
        records = build_records(entries, warodai)
        write_atomically(output_path, render_html(records))
        output_path
      end

      private

      def ensure_unique_entries!(entries)
        duplicates = entries.group_by(&:jmdict_id).select { |_id, matches| matches.length > 1 }
        return if duplicates.empty?

        detail = duplicates.map do |id, matches|
          "#{id} (#{matches.map(&:romaji).join(', ')})"
        end.join('; ')
        raise ArgumentError, "duplicate JMdict IDs: #{detail}"
      end

      def build_records(entries, warodai)
        matches_by_id = warodai_matches(entries, warodai)
        entries.sort_by { |entry| [entry.title.to_s, entry.primary_reading.to_s, entry.jmdict_id] }.map do |entry|
          record = entry_record(entry, matches_by_id.fetch(entry.jmdict_id, []))
          record[:primary_search] = primary_search_values(record)
          record[:search_text] = search_values(record).join(' ')
          record
        end
      end

      def warodai_matches(entries, warodai)
        query_owners = Hash.new { |hash, key| hash[key] = [] }
        entries.each do |entry|
          form_reading_pairs(entry).each do |written, reading|
            query_owners[[written, reading]] << entry.jmdict_id
          end
        end

        queries = query_owners.keys.map { |written, reading| { written:, reading: } }
        matches = queries.empty? ? [] : warodai.lookup_many(queries)
        by_entry = Hash.new { |hash, key| hash[key] = {} }
        query_owners.keys.each_with_index do |key, index|
          query_owners[key].each do |entry_id|
            matches[index].each { |match| by_entry[entry_id][match[:card_id]] = match }
          end
        end

        by_entry.transform_values { |cards| cards.values.sort_by { |card| card[:card_id] } }
      end

      def form_reading_pairs(entry)
        written_by_id = entry.written_forms.to_h { |form| [form.id, form.text] }
        all_written = entry.written_forms.map(&:text)

        entry.readings.flat_map do |reading|
          written = if all_written.empty? || reading.no_kanji
                      [nil]
                    elsif reading.applies_to_written_forms.empty? || reading.applies_to_written_forms.include?('*')
                      all_written
                    else
                      reading.applies_to_written_forms.filter_map do |reference|
                        written_by_id[reference] || (all_written.include?(reference) ? reference : nil)
                      end
                    end
          written.map { |form| [form, reading.text] }
        end.uniq
      end

      def entry_record(entry, warodai_matches)
        {
          id: entry.jmdict_id,
          title: entry.title,
          primary_reading: entry.primary_reading,
          romaji: entry.romaji,
          status: entry.entry_status,
          profile: entry.quality_profile,
          written_forms: entry.written_forms.map { |form| { id: form.id, text: form.text } },
          readings: entry.readings.map do |reading|
            {
              id: reading.id,
              text: reading.text,
              no_kanji: reading.no_kanji,
              applies_to_written_forms: reading.applies_to_written_forms,
              information: reading.information,
              priorities: reading.priorities
            }
          end,
          senses: entry.senses.map { |sense| sense_record(sense) },
          pronunciations: entry.pronunciations.filter_map do |item|
            next if blank?(item.explanation_uk)

            {
              id: item.id,
              reading: item.reading,
              explanation_uk: item.explanation_uk,
              pattern: item.pattern,
              mora_pattern: item.mora_pattern,
              status: item.status
            }
          end,
          media_notes: entry.media.filter_map do |item|
            next if blank?(item.learner_note_uk)

            {
              id: item.id,
              text: item.text,
              reading: item.reading,
              learner_note_uk: item.learner_note_uk,
              recording_type: item.recording_type
            }
          end,
          warodai: warodai_matches.map { |match| warodai_record(match) }
        }
      end

      def sense_record(sense)
        {
          id: sense.id,
          source_index: sense.source_sense_index,
          learner_priority: sense.learner_priority,
          applies_to_written: sense.applies_to_written,
          applies_to_readings: sense.applies_to_readings,
          parts_of_speech: sense.parts_of_speech,
          miscellaneous: sense.miscellaneous,
          fields: sense.fields,
          dialects: sense.dialects,
          sense_information: sense.sense_information,
          english_glosses: sense.english_glosses.filter_map do |gloss|
            next unless gloss.lang == 'eng' && !blank?(gloss.text)

            { text: gloss.text, type: gloss.type, gender: gloss.gender, primary: gloss.primary }
          end,
          ukrainian_glosses: sense.ukrainian_glosses.filter_map do |gloss|
            next if blank?(gloss.text)

            {
              id: gloss.id,
              text: gloss.text,
              qualifier: gloss.qualifier,
              status: gloss.status
            }
          end,
          learner_notes: sense.learner_notes.filter_map do |note|
            next if blank?(note.uk)

            { id: note.id, uk: note.uk, level: note.level, register: note.register, status: note.status }
          end,
          collocations: sense.collocations.filter_map do |item|
            next if [item.ja, item.reading, item.uk].all? { |value| blank?(value) }

            {
              id: item.id, ja: item.ja, reading: item.reading, uk: item.uk,
              pattern: item.pattern, register: item.register, status: item.status
            }
          end,
          constructions: sense.constructions.filter_map do |item|
            next if [item.target, item.uk].all? { |value| blank?(value) }

            {
              id: item.id, relation: item.relation, target: item.target, target_id: item.target_id,
              reading: item.reading, uk: item.uk, status: item.status
            }
          end,
          related_words: sense.related_words.filter_map do |item|
            next if [item.target, item.uk, item.uk_context, item.note].all? { |value| blank?(value) }

            {
              id: item.id, relation: item.relation, target: item.target, target_id: item.target_id,
              reading: item.reading, uk: item.uk, uk_context: item.uk_context,
              note: item.note, status: item.status
            }
          end,
          idioms: sense.idioms.filter_map do |item|
            next if [item.ja, item.reading, item.uk].all? { |value| blank?(value) }

            {
              id: item.id, ja: item.ja, reading: item.reading, uk: item.uk, en: item.en,
              level: item.level, register: item.register, status: item.status
            }
          end,
          examples: sense.examples.filter_map do |item|
            next if [item.ja, item.reading, item.uk, item.en].all? { |value| blank?(value) }

            {
              id: item.id, ja: item.ja, reading: item.reading, romaji: item.romaji,
              uk: item.uk, en: item.en, focus: item.focus, level: item.level,
              register: item.register, status: item.status
            }
          end
        }
      end

      def warodai_record(match)
        {
          card_id: match[:card_id],
          header: match[:header],
          kana_forms: match[:kana_forms],
          written_forms: match[:written_forms],
          polivanov: match[:polivanov],
          corpus_codes: match[:corpus_codes],
          body_lines: match[:body_lines]
        }
      end

      def primary_search_values(record)
        [
          record[:id].to_s,
          record[:title],
          record[:primary_reading],
          record[:romaji],
          *record[:written_forms].map { |form| form[:text] },
          *record[:readings].map { |reading| reading[:text] }
        ].compact.uniq
      end

      def search_values(record)
        values = primary_search_values(record)
        record[:senses].each do |sense|
          values.concat(sense[:english_glosses].map { |item| item[:text] })
          values.concat(sense[:ukrainian_glosses].map { |item| [item[:text], item[:qualifier]] })
          values.concat(sense[:learner_notes].map { |item| item[:uk] })
          values.concat(sense[:collocations].map { |item| item.values_at(:ja, :reading, :uk, :pattern) })
          values.concat(sense[:constructions].map { |item| item.values_at(:target, :reading, :uk) })
          values.concat(sense[:related_words].map { |item| item.values_at(:target, :reading, :uk, :uk_context, :note) })
          values.concat(sense[:idioms].map { |item| item.values_at(:ja, :reading, :uk, :en) })
          values.concat(sense[:examples].map { |item| item.values_at(:ja, :reading, :romaji, :uk, :en, :focus) })
        end
        values.concat(record[:pronunciations].map { |item| item.values_at(:reading, :explanation_uk) })
        values.concat(record[:media_notes].map { |item| item.values_at(:text, :reading, :learner_note_uk) })
        values.concat(record[:warodai].map do |item|
          [item[:card_id], item[:header], item[:polivanov], item[:kana_forms], item[:written_forms], item[:body_lines]]
        end)
        values.flatten.compact.reject { |value| blank?(value) }
      end

      def blank?(value)
        value.nil? || value.to_s.strip.empty?
      end

      def json_for_script(value)
        JSON.generate(value)
            .gsub('&', '\\u0026')
            .gsub('<', '\\u003c')
            .gsub('>', '\\u003e')
            .gsub("\u2028", '\\u2028')
            .gsub("\u2029", '\\u2029')
      end

      def write_atomically(output_path, content)
        output_path = File.expand_path(output_path)
        building_path = "#{output_path}.building"
        FileUtils.mkdir_p(File.dirname(output_path))
        FileUtils.rm_f(building_path)
        File.write(building_path, content, encoding: Encoding::UTF_8)
        FileUtils.mv(building_path, output_path)
      ensure
        FileUtils.rm_f(building_path) if defined?(building_path)
      end

      def render_html(records)
        data = json_for_script(records)
        generated_at = Time.now.utc.iso8601
        <<~HTML
          <!doctype html>
          <html lang="uk">
          <head>
            <meta charset="utf-8">
            <meta name="viewport" content="width=device-width, initial-scale=1">
            <title>Jibiki dictionary comparison</title>
            <style>
              :root { color-scheme: light dark; --bg:#f4f6fa; --surface:#fff; --text:#172033; --muted:#637083; --border:#d9deea; --uk:#1769aa; --uk-bg:#edf6ff; --ru:#a64632; --ru-bg:#fff2ee; --en:#24725b; --en-bg:#eef9f4; --mark:#ffe48a; --shadow:0 8px 24px rgba(23,32,51,.08); }
              * { box-sizing:border-box; }
              body { margin:0; background:var(--bg); color:var(--text); font:16px/1.55 system-ui,-apple-system,"Segoe UI","Noto Sans JP",sans-serif; }
              button,input,summary { font:inherit; }
              .container { width:min(1120px,calc(100% - 2rem)); margin:auto; }
              header { padding:2.2rem 0 1.3rem; }
              h1 { margin:0; font-size:clamp(1.8rem,5vw,3rem); letter-spacing:-.035em; }
              .subtitle,.muted { color:var(--muted); }
              .warning { margin:1rem 0 1.4rem; padding:1rem 1.1rem; border:1px solid #d7953e; border-radius:.75rem; background:#fff7e8; color:#553511; }
              .search-panel { position:sticky; top:0; z-index:10; padding:.8rem 0 1rem; background:color-mix(in srgb,var(--bg) 92%,transparent); backdrop-filter:blur(12px); }
              label { display:block; margin-bottom:.4rem; font-weight:700; }
              input[type="search"] { width:100%; padding:.9rem 1rem; border:1px solid var(--border); border-radius:.75rem; background:var(--surface); color:var(--text); box-shadow:var(--shadow); }
              input[type="search"]:focus { outline:3px solid color-mix(in srgb,var(--uk) 25%,transparent); border-color:var(--uk); }
              .toolbar { display:flex; align-items:center; justify-content:space-between; gap:.8rem; min-height:2.7rem; margin-top:.55rem; }
              .toolbar-actions { display:flex; gap:.45rem; }
              button { border:1px solid var(--border); border-radius:.55rem; padding:.42rem .7rem; background:var(--surface); color:var(--text); cursor:pointer; }
              button:hover { border-color:var(--uk); }
              #results { display:grid; gap:1rem; padding-bottom:2rem; }
              .entry-card { overflow:hidden; border:1px solid var(--border); border-radius:1rem; background:var(--surface); box-shadow:var(--shadow); }
              .entry-head { padding:1.15rem 1.2rem; border-bottom:1px solid var(--border); }
              .entry-title { display:flex; flex-wrap:wrap; align-items:baseline; gap:.5rem .8rem; margin:0 0 .35rem; }
              .headword { font-size:1.75rem; font-weight:800; }
              .reading { font-size:1.05rem; color:var(--muted); }
              .badges { display:flex; flex-wrap:wrap; gap:.35rem; }
              .badge { display:inline-block; padding:.12rem .42rem; border:1px solid var(--border); border-radius:999px; color:var(--muted); font-size:.76rem; }
              details.language-section { border-bottom:1px solid var(--border); }
              details.language-section:last-child { border-bottom:0; }
              summary { display:flex; align-items:center; justify-content:space-between; gap:1rem; padding:.85rem 1.2rem; cursor:pointer; font-weight:800; list-style:none; }
              summary::-webkit-details-marker { display:none; }
              summary::after { content:"＋"; font-size:1.2rem; }
              details[open] > summary::after { content:"−"; }
              .language-section.uk > summary { color:var(--uk); background:var(--uk-bg); }
              .language-section.ru > summary { color:var(--ru); background:var(--ru-bg); }
              .language-section.en > summary { color:var(--en); background:var(--en-bg); }
              .section-body { padding:1rem 1.2rem 1.25rem; }
              .sense { padding:.85rem 0; border-top:1px dashed var(--border); }
              .sense:first-child { padding-top:0; border-top:0; }
              .sense h3,.block h4 { margin:0 0 .45rem; }
              .block { margin:.8rem 0 0; }
              .items { display:grid; gap:.55rem; margin:0; padding:0; list-style:none; }
              .item { padding:.7rem .8rem; border-left:3px solid var(--border); border-radius:.35rem; background:color-mix(in srgb,var(--surface) 88%,var(--bg)); }
              .ja { font-size:1.05rem; }
              .translation { margin-top:.2rem; }
              .meta-line { display:flex; flex-wrap:wrap; gap:.35rem; margin-top:.35rem; }
              .warodai-card { margin:.8rem 0; padding:.85rem; border:1px solid color-mix(in srgb,var(--ru) 28%,var(--border)); border-radius:.65rem; }
              .warodai-line { margin:.35rem 0; white-space:pre-wrap; }
              .warodai-ref { text-decoration:underline dotted; text-underline-offset:.15em; }
              mark { padding:0 .08em; border-radius:.15em; background:var(--mark); color:#27200a; }
              .empty { padding:1.2rem; text-align:center; color:var(--muted); }
              footer { padding:1.5rem 0 3rem; border-top:1px solid var(--border); color:var(--muted); font-size:.9rem; }
              @media (prefers-color-scheme:dark) { :root { --bg:#111827; --surface:#1d2637; --text:#edf2f8; --muted:#aab4c4; --border:#364258; --uk:#75bfff; --uk-bg:#172d43; --ru:#ff9d87; --ru-bg:#42241f; --en:#79d3b6; --en-bg:#17372e; --mark:#705b00; --shadow:0 8px 24px rgba(0,0,0,.22); } .warning { background:#3b2c16; color:#ffe0a6; } }
              @media (max-width:640px) { .container { width:min(100% - 1rem,1120px); } header { padding-top:1.2rem; } .toolbar { align-items:flex-start; flex-direction:column; } .entry-head,summary,.section-body { padding-left:.85rem; padding-right:.85rem; } }
            </style>
          </head>
          <body>
            <header class="container">
              <h1>Jibiki comparison dictionary</h1>
              <p class="subtitle">Ukrainian authored content · Warodai Russian reference · JMdict English</p>
              <aside class="warning"><strong>Private local QA only.</strong> This file embeds verbatim Warodai text under CC BY-NC-ND 3.0. Do not commit, publish, translate, adapt, or redistribute it.</aside>
            </header>
            <main class="container">
              <section class="search-panel" aria-label="Dictionary search">
                <label for="query">Search all languages</label>
                <input id="query" type="search" autocomplete="off" placeholder="貿易 · boueki · зовнішня торгівля · foreign trade">
                <div class="toolbar">
                  <div id="status" class="muted" role="status" aria-live="polite">Enter a word or phrase to compare dictionary content.</div>
                  <div class="toolbar-actions">
                    <button id="expand-all" type="button">Expand all</button>
                    <button id="collapse-all" type="button">Collapse all</button>
                  </div>
                </div>
              </section>
              <section id="results" aria-label="Search results"></section>
            </main>
            <footer class="container">
              <p>Generated #{generated_at}. Ukrainian project content and the imported JMdict layer are CC BY-SA 4.0. JMdict is copyright the Electronic Dictionary Research and Development Group and used under its licence.</p>
              <p>Warodai is consulted privately for read-only comparison and remains CC BY-NC-ND 3.0. It is not project content.</p>
            </footer>
            <script id="dictionary-data" type="application/json">#{data}</script>
            <script>
              (() => {
                'use strict';
                const entries = JSON.parse(document.getElementById('dictionary-data').textContent);
                const queryInput = document.getElementById('query');
                const results = document.getElementById('results');
                const status = document.getElementById('status');
                const MAX_RESULTS = #{MAX_RESULTS};
                const normalize = value => String(value ?? '').normalize('NFC').toLocaleLowerCase();
                const tokensFor = value => normalize(value).trim().split(/\s+/u).filter(Boolean);
                const element = (tag, className, text) => {
                  const node = document.createElement(tag);
                  if (className) node.className = className;
                  if (text !== undefined) node.textContent = text;
                  return node;
                };
                const escapeRegex = value => value.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');

                function appendHighlighted(parent, value, tokens, language) {
                  const wrapper = element('span');
                  if (language) wrapper.lang = language;
                  const text = String(value ?? '');
                  if (!tokens.length) {
                    wrapper.textContent = text;
                  } else {
                    const pattern = new RegExp(`(${tokens.map(escapeRegex).join('|')})`, 'giu');
                    text.split(pattern).filter(part => part !== '').forEach(part => {
                      const isMatch = tokens.some(token => normalize(part) === token);
                      wrapper.append(isMatch ? element('mark', null, part) : document.createTextNode(part));
                    });
                  }
                  parent.append(wrapper);
                  return wrapper;
                }

                function badge(value) {
                  return element('span', 'badge', value);
                }

                function addBadges(parent, values) {
                  const row = element('div', 'meta-line');
                  values.filter(value => value !== null && value !== undefined && String(value).trim() !== '')
                    .forEach(value => row.append(badge(value)));
                  if (row.childNodes.length) parent.append(row);
                }

                function addTextLine(parent, label, value, tokens, language) {
                  if (value === null || value === undefined || String(value).trim() === '') return;
                  const line = element('div', 'translation');
                  if (label) line.append(element('strong', null, `${label}: `));
                  appendHighlighted(line, value, tokens, language);
                  parent.append(line);
                }

                function listBlock(parent, title, items, renderItem) {
                  if (!items || !items.length) return;
                  const block = element('section', 'block');
                  block.append(element('h4', null, title));
                  const list = element('ul', 'items');
                  items.forEach(item => {
                    const row = element('li', 'item');
                    renderItem(row, item);
                    list.append(row);
                  });
                  block.append(list);
                  parent.append(block);
                }

                function hasUkrainian(sense) {
                  return ['ukrainian_glosses','learner_notes','collocations','constructions','related_words','idioms','examples']
                    .some(key => sense[key] && sense[key].length);
                }

                function renderUkrainian(entry, body, tokens) {
                  entry.senses.filter(hasUkrainian).forEach(sense => {
                    const section = element('section', 'sense');
                    section.append(element('h3', null, `Sense ${sense.source_index}`));
                    addBadges(section, [sense.id, sense.learner_priority]);
                    listBlock(section, 'Glosses', sense.ukrainian_glosses, (row, item) => {
                      appendHighlighted(row, item.text, tokens, 'uk');
                      addBadges(row, [item.qualifier, item.status]);
                    });
                    listBlock(section, 'Learner notes', sense.learner_notes, (row, item) => {
                      appendHighlighted(row, item.uk, tokens, 'uk');
                      addBadges(row, [item.level, item.register, item.status, item.id]);
                    });
                    listBlock(section, 'Collocations', sense.collocations, (row, item) => {
                      addTextLine(row, null, item.ja, tokens, 'ja');
                      addTextLine(row, 'Reading', item.reading, tokens, 'ja');
                      addTextLine(row, 'UK', item.uk, tokens, 'uk');
                      addTextLine(row, 'Pattern', item.pattern, tokens);
                      addBadges(row, [item.register, item.status, item.id]);
                    });
                    listBlock(section, 'Constructions and derivatives', sense.constructions, (row, item) => {
                      addTextLine(row, item.relation, item.target, tokens, 'ja');
                      addTextLine(row, 'Reading', item.reading, tokens, 'ja');
                      addTextLine(row, 'UK', item.uk, tokens, 'uk');
                      addBadges(row, [item.target_id, item.status, item.id]);
                    });
                    listBlock(section, 'Related words', sense.related_words, (row, item) => {
                      addTextLine(row, item.relation, item.target, tokens, 'ja');
                      addTextLine(row, 'Reading', item.reading, tokens, 'ja');
                      addTextLine(row, 'UK', item.uk, tokens, 'uk');
                      addTextLine(row, 'Context', item.uk_context, tokens, 'uk');
                      addTextLine(row, 'Note', item.note, tokens, 'uk');
                      addBadges(row, [item.target_id, item.status, item.id]);
                    });
                    listBlock(section, 'Idioms and proverbs', sense.idioms, (row, item) => {
                      addTextLine(row, null, item.ja, tokens, 'ja');
                      addTextLine(row, 'Reading', item.reading, tokens, 'ja');
                      addTextLine(row, 'UK', item.uk, tokens, 'uk');
                      addTextLine(row, 'EN', item.en, tokens, 'en');
                      addBadges(row, [item.level, item.register, item.status, item.id]);
                    });
                    listBlock(section, 'Examples', sense.examples, (row, item) => {
                      addTextLine(row, null, item.ja, tokens, 'ja');
                      addTextLine(row, 'Reading', item.reading, tokens, 'ja');
                      addTextLine(row, 'Romaji', item.romaji, tokens);
                      addTextLine(row, 'UK', item.uk, tokens, 'uk');
                      addTextLine(row, 'EN', item.en, tokens, 'en');
                      addBadges(row, [item.level, item.register, item.status, item.id]);
                    });
                    body.append(section);
                  });
                  listBlock(body, 'Pronunciation notes', entry.pronunciations, (row, item) => {
                    addTextLine(row, 'Reading', item.reading, tokens, 'ja');
                    addTextLine(row, null, item.explanation_uk, tokens, 'uk');
                    addBadges(row, [item.pattern, item.mora_pattern, item.status, item.id]);
                  });
                  listBlock(body, 'Media notes', entry.media_notes, (row, item) => {
                    addTextLine(row, null, item.text, tokens, 'ja');
                    addTextLine(row, 'Reading', item.reading, tokens, 'ja');
                    addTextLine(row, null, item.learner_note_uk, tokens, 'uk');
                    addBadges(row, [item.recording_type, item.id]);
                  });
                  if (!body.childNodes.length) body.append(element('p', 'empty', 'No Ukrainian content recorded.'));
                }

                function appendWarodaiMarkup(parent, raw, tokens) {
                  const template = document.createElement('template');
                  template.innerHTML = raw;
                  const copy = (source, target) => {
                    source.childNodes.forEach(node => {
                      if (node.nodeType === Node.TEXT_NODE) {
                        appendHighlighted(target, node.textContent, tokens, 'ru');
                      } else if (node.nodeType === Node.ELEMENT_NODE && node.tagName === 'I') {
                        const emphasis = element('em');
                        copy(node, emphasis);
                        target.append(emphasis);
                      } else if (node.nodeType === Node.ELEMENT_NODE && node.tagName === 'A' && /^#\d{3}-\d{2}-\d{2}$/.test(node.getAttribute('href') || '')) {
                        const reference = element('span', 'warodai-ref');
                        reference.title = `Warodai reference ${node.getAttribute('href').slice(1)}`;
                        copy(node, reference);
                        target.append(reference);
                      } else if (node.nodeType === Node.ELEMENT_NODE) {
                        appendHighlighted(target, node.outerHTML, tokens, 'ru');
                      }
                    });
                  };
                  copy(template.content, parent);
                }

                function renderWarodai(entry, body, tokens) {
                  if (!entry.warodai.length) {
                    body.append(element('p', 'empty', 'No exact Warodai match.'));
                    return;
                  }
                  entry.warodai.forEach(card => {
                    const wrapper = element('article', 'warodai-card');
                    wrapper.id = `warodai-${card.card_id}`;
                    const heading = element('h3');
                    appendHighlighted(heading, card.header, tokens, 'ja');
                    wrapper.append(heading);
                    addBadges(wrapper, [card.card_id, card.polivanov, ...card.corpus_codes]);
                    card.body_lines.forEach(line => {
                      const paragraph = element('p', 'warodai-line');
                      appendWarodaiMarkup(paragraph, line, tokens);
                      wrapper.append(paragraph);
                    });
                    body.append(wrapper);
                  });
                }

                function renderEnglish(entry, body, tokens) {
                  const senses = entry.senses.filter(sense => sense.english_glosses.length);
                  senses.forEach(sense => {
                    const section = element('section', 'sense');
                    section.append(element('h3', null, `Sense ${sense.source_index}`));
                    addBadges(section, [sense.id, sense.learner_priority, ...sense.parts_of_speech, ...sense.miscellaneous, ...sense.fields, ...sense.dialects]);
                    if (sense.applies_to_written.length && !sense.applies_to_written.includes('*')) {
                      addTextLine(section, 'Written forms', sense.applies_to_written.join(', '), tokens, 'ja');
                    }
                    if (sense.applies_to_readings.length && !sense.applies_to_readings.includes('*')) {
                      addTextLine(section, 'Readings', sense.applies_to_readings.join(', '), tokens, 'ja');
                    }
                    sense.sense_information.forEach(value => addTextLine(section, 'Info', value, tokens, 'en'));
                    const glosses = element('ol', 'items');
                    sense.english_glosses.forEach(gloss => {
                      const row = element('li', 'item');
                      appendHighlighted(row, gloss.text, tokens, 'en');
                      addBadges(row, [gloss.type !== 'plain' ? gloss.type : null, gloss.gender !== 'none' ? gloss.gender : null, gloss.primary ? 'primary' : null]);
                      glosses.append(row);
                    });
                    section.append(glosses);
                    body.append(section);
                  });
                  if (!senses.length) body.append(element('p', 'empty', 'No English JMdict glosses recorded.'));
                }

                function languageSection(kind, title, open, entry, tokens, renderer) {
                  const details = element('details', `language-section ${kind}`);
                  details.open = open;
                  details.lang = kind === 'uk' ? 'uk' : kind === 'ru' ? 'ru' : 'en';
                  details.append(element('summary', null, title));
                  const body = element('div', 'section-body');
                  renderer(entry, body, tokens);
                  details.append(body);
                  return details;
                }

                function renderEntry(entry, tokens) {
                  const card = element('article', 'entry-card');
                  const head = element('header', 'entry-head');
                  const title = element('h2', 'entry-title');
                  appendHighlighted(title, entry.title, tokens, 'ja').classList.add('headword');
                  appendHighlighted(title, entry.primary_reading, tokens, 'ja').classList.add('reading');
                  head.append(title);
                  const forms = entry.written_forms.map(item => item.text).join(' · ');
                  const readings = entry.readings.map(item => item.text).join(' · ');
                  if (forms && forms !== entry.title) addTextLine(head, 'Forms', forms, tokens, 'ja');
                  if (readings && readings !== entry.primary_reading) addTextLine(head, 'Readings', readings, tokens, 'ja');
                  addBadges(head, [`JMdict ${entry.id}`, entry.romaji, entry.profile, entry.status]);
                  card.append(head);
                  card.append(languageSection('uk', 'Ukrainian authored content', true, entry, tokens, renderUkrainian));
                  card.append(languageSection('ru', 'Warodai · Russian reference', false, entry, tokens, renderWarodai));
                  card.append(languageSection('en', 'JMdict · English', false, entry, tokens, renderEnglish));
                  return card;
                }

                function scoreEntry(entry, tokens) {
                  const search = normalize(entry.search_text);
                  if (!tokens.every(token => search.includes(token))) return null;
                  const primary = entry.primary_search.map(normalize);
                  return tokens.reduce((score, token) => {
                    if (primary.some(value => value === token)) return score + 1000;
                    if (primary.some(value => value.startsWith(token))) return score + 300;
                    if (primary.some(value => value.includes(token))) return score + 100;
                    return score + 10;
                  }, 0);
                }

                function updateResults() {
                  const tokens = tokensFor(queryInput.value);
                  results.replaceChildren();
                  if (!tokens.length) {
                    status.textContent = 'Enter a word or phrase to compare dictionary content.';
                    return;
                  }
                  const matched = entries.map(entry => ({entry, score: scoreEntry(entry, tokens)}))
                    .filter(item => item.score !== null)
                    .sort((left, right) => right.score - left.score || left.entry.title.localeCompare(right.entry.title, 'ja'));
                  matched.slice(0, MAX_RESULTS).forEach(item => results.append(renderEntry(item.entry, tokens)));
                  status.textContent = matched.length > MAX_RESULTS
                    ? `${matched.length} matches; showing the first ${MAX_RESULTS}. Refine the query to narrow results.`
                    : `${matched.length} ${matched.length === 1 ? 'match' : 'matches'}.`;
                  if (!matched.length) results.append(element('p', 'empty', 'No matching dictionary entries.'));
                }

                queryInput.addEventListener('input', updateResults);
                document.getElementById('expand-all').addEventListener('click', () => {
                  results.querySelectorAll('details').forEach(details => { details.open = true; });
                });
                document.getElementById('collapse-all').addEventListener('click', () => {
                  results.querySelectorAll('details').forEach(details => { details.open = false; });
                });
              })();
            </script>
          </body>
          </html>
        HTML
      end
    end
  end
end
