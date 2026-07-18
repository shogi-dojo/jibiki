# frozen_string_literal: true

require_relative 'org_entry/document'
require_relative 'org_entry/model'

module OrgEntry
  def self.load(filepath)
    doc = Document.load(filepath)
    Entry.new(doc)
  end
end
