#!/usr/bin/env ruby
# frozen_string_literal: true

# bundle exec ruby scripts/audit_kanji_drafts.rb [ignored-output.json]
# This checks transliteration/coverage only; a clean report does not verify source meaning fidelity.
require 'json'
require 'fileutils'
require_relative '../lib/kanji/draft_audit'

root = File.expand_path('..', __dir__)
policy_path = File.join(root, 'drafts/kanji/audit-policy.json')
policy = JSON.parse(File.read(policy_path))
records = Dir[File.join(root, 'kanji/U+*.org')].sort.map { |path| Kanji::Record.load(path) }
report = Kanji::DraftAudit.call(records, policy).merge(policy: 'drafts/kanji/audit-policy.json')
output = ARGV.fetch(0, File.join(root, 'notes/kanji-draft-audit.json'))
FileUtils.mkdir_p(File.dirname(output))
File.write(output, "#{JSON.pretty_generate(report)}\n")
puts JSON.pretty_generate(report.reject { |key, _| %i[findings missing_drafts metadata_only_drafts foreign_script_drafts].include?(key) }
                               .merge(findings: report[:findings].size, missing_drafts: report[:missing_drafts].size,
                                      metadata_only_drafts: report[:metadata_only_drafts].size,
                                      foreign_script_drafts: report[:foreign_script_drafts].size, output: output))
