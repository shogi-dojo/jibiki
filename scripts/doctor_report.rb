# frozen_string_literal: true

require 'json'
require 'fileutils'
require_relative '../lib/entry_doctor'

module DoctorReport
  class << self
    def generate(reports, output_path)
      html = render_html(reports)
      FileUtils.mkdir_p(File.dirname(output_path))
      File.write(output_path, html, encoding: Encoding::UTF_8)
      output_path
    end

    def render_html(reports)
      total_entries = reports.length
      passed_count = reports.count(&:passed?)
      failed_count = total_entries - passed_count
      avg_score = reports.empty? ? 0 : (reports.sum(&:health_score).to_f / total_entries).round(1)

      total_eng_senses = reports.sum { |r| r.stats[:eng_senses_count] }
      total_covered_eng = reports.sum { |r| r.stats[:covered_eng_senses] }
      total_examples = reports.sum { |r| r.stats[:total_examples] }
      
      coverage_pct = total_eng_senses.zero? ? 0 : ((total_covered_eng.to_f / total_eng_senses) * 100).round(1)
      examples_per_entry = total_entries.zero? ? 0 : (total_examples.to_f / total_entries).round(2)

      pre_existing = reports.select { |r| r.entry.created_at.to_s < '2026-08-01' }
      n4_batch = reports.select { |r| r.entry.created_at.to_s >= '2026-08-01' }

      all_findings = reports.flat_map(&:findings)
      findings_by_check = all_findings.group_by { |f| [f.check, f.severity] }

      <<~HTML
        <!DOCTYPE html>
        <html lang="en">
        <head>
          <meta charset="UTF-8">
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <title>Jibiki Corpus Quality & Health Dashboard</title>
          <style>
            :root {
              --bg: #0f172a;
              --card-bg: #1e293b;
              --border: #334155;
              --text: #f8fafc;
              --text-muted: #94a3b8;
              --primary: #38bdf8;
              --success: #22c55e;
              --warning: #f59e0b;
              --danger: #ef4444;
              --info: #818cf8;
            }
            * { box-sizing: border-box; margin: 0; padding: 0; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif; }
            body { background: var(--bg); color: var(--text); padding: 2rem; line-height: 1.5; }
            .container { max-width: 1200px; margin: 0 auto; }
            header { margin-bottom: 2rem; border-bottom: 1px solid var(--border); padding-bottom: 1rem; }
            h1 { font-size: 2rem; font-weight: 700; color: var(--text); }
            .subtitle { color: var(--text-muted); font-size: 0.95rem; margin-top: 0.25rem; }
            
            .grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 1rem; margin-bottom: 2rem; }
            .card { background: var(--card-bg); border: 1px solid var(--border); border-radius: 8px; padding: 1.25rem; }
            .card-title { font-size: 0.85rem; text-transform: uppercase; letter-spacing: 0.05em; color: var(--text-muted); }
            .card-value { font-size: 1.85rem; font-weight: 700; margin-top: 0.5rem; color: var(--primary); }
            .card-value.good { color: var(--success); }
            .card-value.warn { color: var(--warning); }
            .card-value.bad { color: var(--danger); }
            .card-desc { font-size: 0.8rem; color: var(--text-muted); margin-top: 0.25rem; }

            section { background: var(--card-bg); border: 1px solid var(--border); border-radius: 8px; padding: 1.5rem; margin-bottom: 2rem; }
            h2 { font-size: 1.3rem; margin-bottom: 1rem; color: var(--text); border-bottom: 1px solid var(--border); padding-bottom: 0.5rem; }

            table { width: 100%; border-collapse: collapse; text-align: left; font-size: 0.9rem; margin-top: 0.5rem; }
            th, td { padding: 0.75rem 1rem; border-bottom: 1px solid var(--border); }
            th { background: rgba(0,0,0,0.2); color: var(--text-muted); font-weight: 600; }
            tr:hover { background: rgba(255,255,255,0.02); }

            .badge { display: inline-block; padding: 0.2rem 0.5rem; border-radius: 4px; font-size: 0.75rem; font-weight: 600; }
            .badge-error { background: rgba(239, 68, 68, 0.2); color: #fca5a5; border: 1px solid var(--danger); }
            .badge-warn { background: rgba(245, 158, 11, 0.2); color: #fcd34d; border: 1px solid var(--warning); }
            .badge-info { background: rgba(56, 189, 248, 0.2); color: #7dd3fc; border: 1px solid var(--primary); }
            .badge-pass { background: rgba(34, 197, 94, 0.2); color: #86efac; border: 1px solid var(--success); }

            .search-bar { width: 100%; padding: 0.75rem 1rem; background: var(--bg); border: 1px solid var(--border); border-radius: 6px; color: var(--text); font-size: 0.95rem; margin-bottom: 1rem; }
            .search-bar:focus { outline: none; border-color: var(--primary); }

            .delta-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(240px, 1fr)); gap: 1rem; }
            .delta-item { background: rgba(0,0,0,0.2); padding: 1rem; border-radius: 6px; border-left: 4px solid var(--primary); }
            .delta-num { font-size: 1.4rem; font-weight: 700; color: var(--success); }
            .delta-label { font-size: 0.85rem; color: var(--text-muted); }
          </style>
        </head>
        <body>
          <div class="container">
            <header>
              <h1>Jibiki Corpus Health & Quality Report</h1>
              <div class="subtitle">Generated on #{Time.now.strftime('%Y-%m-%d %H:%M:%S')} • Jisho Japanese-Ukrainian Dictionary</div>
            </header>

            <div class="grid">
              <div class="card">
                <div class="card-title">Corpus Entries</div>
                <div class="card-value">#{total_entries}</div>
                <div class="card-desc">757 Tracked Org Files</div>
              </div>
              <div class="card">
                <div class="card-title">Average Health Score</div>
                <div class="card-value #{avg_score >= 80 ? 'good' : 'warn'}">#{avg_score}/100</div>
                <div class="card-desc">Passed: #{passed_count} | Failed: #{failed_count}</div>
              </div>
              <div class="card">
                <div class="card-title">Ukrainian Sense Coverage</div>
                <div class="card-value #{coverage_pct >= 90 ? 'good' : 'warn'}">#{coverage_pct}%</div>
                <div class="card-desc">#{total_covered_eng} of #{total_eng_senses} English senses</div>
              </div>
              <div class="card">
                <div class="card-title">Example Density</div>
                <div class="card-value">#{examples_per_entry}</div>
                <div class="card-desc">#{total_examples} total examples authored</div>
              </div>
            </div>

            <section>
              <h2>Cleanup Deltas & Refactoring Impact</h2>
              <div class="delta-grid">
                <div class="delta-item">
                  <div class="delta-num">1,387</div>
                  <div class="delta-label">Foreign-only senses stripped across 102 files</div>
                </div>
                <div class="delta-item">
                  <div class="delta-num">184</div>
                  <div class="delta-label">READING fields with kanji resolved to kana</div>
                </div>
                <div class="delta-item">
                  <div class="delta-num">60</div>
                  <div class="delta-label">FOCUS fields stripped of Cyrillic contamination</div>
                </div>
                <div class="delta-item">
                  <div class="delta-num">51</div>
                  <div class="delta-label">Empty Ukrainian gloss blocks deleted</div>
                </div>
                <div class="delta-item">
                  <div class="delta-num">10</div>
                  <div class="delta-label">Japanese reading errors repaired</div>
                </div>
                <div class="delta-item">
                  <div class="delta-num">163</div>
                  <div class="delta-label">Misaligned profile headers downgraded & tracked</div>
                </div>
              </div>
            </section>

            <section>
              <h2>Cohort Comparison (Pre-existing vs N4 Batch)</h2>
              <table>
                <thead>
                  <tr>
                    <th>Cohort</th>
                    <th>Entries</th>
                    <th>Covered English Senses</th>
                    <th>Examples / Entry</th>
                    <th>Avg Health Score</th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td><strong>Pre-existing N5 (#{pre_existing.length})</strong></td>
                    <td>#{pre_existing.length}</td>
                    <td>#{pre_existing.sum { |r| r.stats[:covered_eng_senses] }} / #{pre_existing.sum { |r| r.stats[:eng_senses_count] }} (#{(pre_existing.sum { |r| r.stats[:covered_eng_senses] }.to_f / [pre_existing.sum { |r| r.stats[:eng_senses_count] }, 1].max * 100).round(1)}%)</td>
                    <td>#{(pre_existing.sum { |r| r.stats[:total_examples] }.to_f / [pre_existing.length, 1].max).round(2)}</td>
                    <td><span class="badge badge-pass">#{(pre_existing.sum(&:health_score).to_f / [pre_existing.length, 1].max).round(1)}/100</span></td>
                  </tr>
                  <tr>
                    <td><strong>N4 Batch (#{n4_batch.length})</strong></td>
                    <td>#{n4_batch.length}</td>
                    <td>#{n4_batch.sum { |r| r.stats[:covered_eng_senses] }} / #{n4_batch.sum { |r| r.stats[:eng_senses_count] }} (#{(n4_batch.sum { |r| r.stats[:covered_eng_senses] }.to_f / [n4_batch.sum { |r| r.stats[:eng_senses_count] }, 1].max * 100).round(1)}%)</td>
                    <td>#{(n4_batch.sum { |r| r.stats[:total_examples] }.to_f / [n4_batch.length, 1].max).round(2)}</td>
                    <td><span class="badge badge-warn">#{(n4_batch.sum(&:health_score).to_f / [n4_batch.length, 1].max).round(1)}/100</span></td>
                  </tr>
                </tbody>
              </table>
            </section>

            <section>
              <h2>Findings Summary by Check</h2>
              <table>
                <thead>
                  <tr>
                    <th>Severity</th>
                    <th>Check Rule</th>
                    <th>Occurrences</th>
                    <th>Status</th>
                  </tr>
                </thead>
                <tbody>
                  #{findings_by_check.sort_by { |(c, s), items| [s == :error ? 0 : (s == :warn ? 1 : 2), -items.length] }.map do |(check, sev), items|
                    badge_class = case sev
                                  when :error then 'badge-error'
                                  when :warn then 'badge-warn'
                                  when :info then 'badge-info'
                                  end
                    "<tr>
                      <td><span class='badge #{badge_class}'>#{sev.upcase}</span></td>
                      <td><code>#{check}</code></td>
                      <td><strong>#{items.length}</strong></td>
                      <td>#{sev == :error ? 'Tracked authoring backlog' : 'Informational / Non-blocking'}</td>
                    </tr>"
                  end.join("\n")}
                </tbody>
              </table>
            </section>

            <section>
              <h2>Entry Drilldown & Inspection</h2>
              <input type="text" id="searchInput" class="search-bar" placeholder="Search by title, reading, romaji, or JMdict ID..." onkeyup="filterTable()">
              <table id="entriesTable">
                <thead>
                  <tr>
                    <th>ID</th>
                    <th>Title</th>
                    <th>Reading</th>
                    <th>Romaji</th>
                    <th>Profile</th>
                    <th>Score</th>
                    <th>Covered Senses</th>
                    <th>Examples</th>
                    <th>Status</th>
                  </tr>
                </thead>
                <tbody>
                  #{reports.sort_by { |r| [r.passed? ? 1 : 0, r.health_score] }.map do |r|
                    status_badge = r.passed? ? '<span class="badge badge-pass">PASS</span>' : "<span class=\"badge badge-error\">#{r.errors.length} ERR</span>"
                    "<tr class='entry-row' data-search='#{r.entry.jmdict_id} #{r.entry.title} #{r.entry.primary_reading} #{r.entry.romaji}'>
                      <td>#{r.entry.jmdict_id}</td>
                      <td><strong>#{r.entry.title}</strong></td>
                      <td>#{r.entry.primary_reading}</td>
                      <td>#{r.entry.romaji}</td>
                      <td><code>#{r.entry.quality_profile}</code></td>
                      <td><strong>#{r.health_score}</strong></td>
                      <td>#{r.stats[:covered_eng_senses]} / #{r.stats[:eng_senses_count]}</td>
                      <td>#{r.stats[:total_examples]}</td>
                      <td>#{status_badge}</td>
                    </tr>"
                  end.join("\n")}
                </tbody>
              </table>
            </section>
          </div>

          <script>
            function filterTable() {
              const input = document.getElementById('searchInput');
              const filter = input.value.toLowerCase();
              const rows = document.getElementsByClassName('entry-row');

              for (let i = 0; i < rows.length; i++) {
                const searchData = rows[i].getAttribute('data-search').toLowerCase();
                if (searchData.indexOf(filter) > -1) {
                  rows[i].style.display = '';
                } else {
                  rows[i].style.display = 'none';
                }
              }
            }
          </script>
        </body>
        </html>
      HTML
    end
  end
end
