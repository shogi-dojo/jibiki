# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/org_entry/document'

class OrgEntryDocumentTest < Minitest::Test
  def test_parse_valid_document
    content = <<~ORG
      #+TITLE: 彼処
      #+JMDICT_ID: 1000320
      #+SCHEMA_VERSION: 2

      * Forms
      ** Written form wf-1000320-001
      :PROPERTIES:
      :TEXT: 彼処
      :END:
      *** Information
      - rK
      * Sense s-1000320-001
      :PROPERTIES:
      :SOURCE_SENSE_INDEX: 1
      :END:
      ** English glosses
      - there
      - over there
      ** Ukrainian glosses
      *** uk-s-1000320-001-001
      :PROPERTIES:
      :STATUS: draft
      :END:
      - text :: там
      - qualifier :: neutral
      ** Learner notes
      *** note-s-1000320-001-001
      :PROPERTIES:
      :STATUS: draft
      :END:
      - UK :: Вказівний займенник
        для позначення місця.
    ORG

    doc = OrgEntry::Document.parse(content)

    assert_equal '彼処', doc.keywords['TITLE']
    assert_equal '1000320', doc.keywords['JMDICT_ID']
    assert_equal '2', doc.keywords['SCHEMA_VERSION']

    assert_equal 2, doc.nodes.length

    forms_node = doc.nodes[0]
    assert_equal 'Forms', forms_node.title
    assert_equal 1, forms_node.level
    assert_equal 1, forms_node.children.length

    wf_node = forms_node.children[0]
    assert_equal 'Written form wf-1000320-001', wf_node.title
    assert_equal '彼処', wf_node.properties['TEXT']
    assert_equal 1, wf_node.children.length

    info_node = wf_node.children[0]
    assert_equal 'Information', info_node.title
    assert_equal 1, info_node.content.length
    assert_equal 'rK', info_node.content[0].value
    assert_nil info_node.content[0].label

    sense_node = doc.nodes[1]
    assert_equal 'Sense s-1000320-001', sense_node.title
    assert_equal '1', sense_node.properties['SOURCE_SENSE_INDEX']

    # Test nested structure and continuations
    uk_glosses_node = sense_node.children[1]
    assert_equal 'Ukrainian glosses', uk_glosses_node.title

    uk_item_node = uk_glosses_node.children[0]
    assert_equal 'uk-s-1000320-001-001', uk_item_node.title
    assert_equal 'draft', uk_item_node.properties['STATUS']
    assert_equal 2, uk_item_node.content.length
    assert_equal 'text', uk_item_node.content[0].label
    assert_equal 'там', uk_item_node.content[0].value
    assert_equal 'qualifier', uk_item_node.content[1].label
    assert_equal 'neutral', uk_item_node.content[1].value

    notes_node = sense_node.children[2]
    note_item_node = notes_node.children[0]
    assert_equal 'UK', note_item_node.content[0].label
    assert_equal 'Вказівний займенник для позначення місця.', note_item_node.content[0].value
  end

  def test_parse_error_heading_skips_level
    content = <<~ORG
      * First Level
      *** Third Level (skipped second)
    ORG

    error = assert_raises(OrgEntry::ParseError) do
      OrgEntry::Document.parse(content)
    end
    assert_equal 2, error.line_number
    assert_match(/skips/, error.message)
  end

  def test_parse_error_first_heading_not_level_1
    content = <<~ORG
      ** First heading is level 2
    ORG

    error = assert_raises(OrgEntry::ParseError) do
      OrgEntry::Document.parse(content)
    end
    assert_equal 1, error.line_number
    assert_match(/First heading must be level 1/, error.message)
  end

  def test_parse_error_drawer_not_immediately_below_heading
    content = <<~ORG
      * Heading
      - some list item
      :PROPERTIES:
      :TEXT: foo
      :END:
    ORG

    error = assert_raises(OrgEntry::ParseError) do
      OrgEntry::Document.parse(content)
    end
    assert_equal 3, error.line_number
    assert_match(/immediately below/, error.message)
  end

  def test_parse_error_duplicate_property
    content = <<~ORG
      * Heading
      :PROPERTIES:
      :TEXT: foo
      :TEXT: bar
      :END:
    ORG

    error = assert_raises(OrgEntry::ParseError) do
      OrgEntry::Document.parse(content)
    end
    assert_equal 4, error.line_number
    assert_match(/Duplicate property/, error.message)
  end

  def test_parse_error_empty_list_item
    content = <<~ORG
      * Heading
      -
    ORG

    error = assert_raises(OrgEntry::ParseError) do
      OrgEntry::Document.parse(content)
    end
    assert_equal 2, error.line_number
    assert_match(/Empty list items/, error.message)
  end

  def test_parse_error_continuation_without_list_item
    content = <<~ORG
      * Heading
        Some text not following list item
    ORG

    error = assert_raises(OrgEntry::ParseError) do
      OrgEntry::Document.parse(content)
    end
    assert_equal 2, error.line_number
    assert_match(/Continuation line must follow/, error.message)
  end

  def test_parse_error_unclosed_drawer
    content = <<~ORG
      * Heading
      :PROPERTIES:
      :TEXT: foo
    ORG

    error = assert_raises(OrgEntry::ParseError) do
      OrgEntry::Document.parse(content)
    end
    assert_equal 3, error.line_number
    assert_match(/ended without closing/i, error.message)
  end

  def test_empty_property_and_keyword_values_are_nil
    content = <<~ORG
      #+TITLE: 分かる
      #+CREATED_AT:

      * Sense s-1-001
      :PROPERTIES:
      :TRANSLATOR_ID: alice
      :REVIEWER_ID:
      :END:
    ORG
    doc = OrgEntry::Document.parse(content)
    assert_nil doc.keywords['CREATED_AT']
    assert doc.keywords.key?('CREATED_AT')
    sense = doc.nodes.first
    assert_equal 'alice', sense.properties['TRANSLATOR_ID']
    assert_nil sense.properties['REVIEWER_ID']
    assert sense.properties.key?('REVIEWER_ID')
  end

  def test_parse_error_trailing_whitespace
    content = <<~ORG
      * Heading 
    ORG

    error = assert_raises(OrgEntry::ParseError) do
      OrgEntry::Document.parse(content)
    end
    assert_equal 1, error.line_number
    assert_match(/Trailing whitespace/, error.message)
  end
end
