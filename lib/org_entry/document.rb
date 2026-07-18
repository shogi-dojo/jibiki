# frozen_string_literal: true

module OrgEntry
  class ParseError < StandardError
    attr_reader :line_number

    def initialize(message, line_number)
      super("Line #{line_number}: #{message}")
      @line_number = line_number
    end
  end

  class Document
    attr_reader :keywords, :nodes

    def initialize(keywords, nodes)
      @keywords = keywords
      @nodes = nodes
    end

    def self.load(filepath)
      parse(File.read(filepath, encoding: 'UTF-8'))
    end

    def self.parse(content)
      keywords = {}
      nodes = []
      node_stack = []
      current_node = nil
      inside_drawer = false
      last_list_item = nil

      lines = content.split("\n", -1)
      # If the file ends with a newline, split with -1 will include an empty string at the end.
      # Let's remove the trailing empty string if the content ends with a newline,
      # but keep it if it is a blank line that we need to parse.
      # Actually, split("\n", -1) returns a trailing empty string if content ends with a newline.
      # If the file has a trailing newline, it's standard, so we can ignore the last empty line if it follows a newline.
      if content.end_with?("\n")
        lines.pop
      end

      lines.each_with_index do |original_line, index|
        line_number = index + 1

        if original_line.include?("\r")
          raise ParseError.new("Carriage return character detected", line_number)
        end
        if original_line.include?("\t")
          raise ParseError.new("Tab character detected", line_number)
        end
        if original_line.end_with?(" ")
          raise ParseError.new("Trailing whitespace detected", line_number)
        end

        # Check blank line
        if original_line.empty? || original_line.match?(/\A\s*\z/)
          last_list_item = nil
          next
        end

        # Check comment outside drawers
        if original_line.start_with?("# ") || original_line == "#"
          if inside_drawer
            raise ParseError.new("Comments are not allowed inside property drawers", line_number)
          end
          last_list_item = nil
          next
        end

        # Check keyword
        if original_line.start_with?("#+")
          if !nodes.empty?
            raise ParseError.new("Keywords must appear at the beginning of the file", line_number)
          end
          if (match = original_line.match(/\A#\+(?<key>[A-Z0-9_]+):\s*(?<value>.*)\z/))
            keywords[match[:key]] = match[:value]
          else
            raise ParseError.new("Malformed keyword definition", line_number)
          end
          last_list_item = nil
          next
        end

        # Check heading
        if original_line.start_with?("*")
          if inside_drawer
            raise ParseError.new("Headings are not allowed inside property drawers (drawer not closed with :END:)", line_number)
          end

          if (match = original_line.match(/\A(\*+)\s+(.*)\z/))
            level = match[1].length
            title = match[2]

            if node_stack.empty?
              if level != 1
                raise ParseError.new("First heading must be level 1", line_number)
              end
            else
              parent_level = node_stack.last.level
              if level > parent_level + 1
                raise ParseError.new("Heading level skips from #{parent_level} to #{level}", line_number)
              end
            end

            # Pop elements off stack until the top is a strict ancestor level
            node_stack.pop while !node_stack.empty? && node_stack.last.level >= level

            new_node = Node.new(level, title, line_number)
            if node_stack.empty?
              nodes << new_node
            else
              parent = node_stack.last
              parent.children << new_node
              new_node.parent = parent
            end

            node_stack.push(new_node)
            current_node = new_node
            last_list_item = nil
          else
            raise ParseError.new("Malformed heading", line_number)
          end
          next
        end

        # Check property drawer tags
        if original_line == ":PROPERTIES:"
          if current_node.nil?
            raise ParseError.new("Property drawer found outside of heading", line_number)
          end
          if inside_drawer
            raise ParseError.new("Property drawer is already open", line_number)
          end
          if !current_node.content.empty? || !current_node.properties.empty?
            raise ParseError.new("Property drawer must be immediately below its owning heading", line_number)
          end

          inside_drawer = true
          last_list_item = nil
          next
        end

        if original_line == ":END:"
          if !inside_drawer
            raise ParseError.new("Unexpected :END: without matching :PROPERTIES:", line_number)
          end

          inside_drawer = false
          last_list_item = nil
          next
        end

        # Handle lines inside drawer
        if inside_drawer
          if (match = original_line.match(/\A:([^:]+):\s*(.*)\z/))
            key = match[1]
            val = match[2]
            if current_node.properties.key?(key)
              raise ParseError.new("Duplicate property :#{key}: inside drawer", line_number)
            end
            current_node.properties[key] = val
          else
            raise ParseError.new("Invalid line inside property drawer", line_number)
          end
          next
        end

        # Check list item
        if original_line.start_with?("- ")
          if current_node.nil?
            raise ParseError.new("List item found outside of heading", line_number)
          end

          content_str = original_line[2..]
          if content_str.strip.empty?
            raise ParseError.new("Empty list items are forbidden", line_number)
          end

          label = nil
          value = content_str
          if content_str.include?(" :: ")
            label, value = content_str.split(" :: ", 2)
          end

          item = ListItem.new(label, value, line_number)
          current_node.content << item
          last_list_item = item
          next
        end

        if original_line == "-"
          raise ParseError.new("Empty list items are forbidden", line_number)
        end

        # Check continuation line
        if original_line.start_with?("  ")
          if last_list_item.nil?
            raise ParseError.new("Continuation line must follow a list item", line_number)
          end
          last_list_item.append_continuation(original_line.strip)
          next
        end

        # Any other line starting with a space or other characters is invalid
        raise ParseError.new("Invalid line format or indentation", line_number)
      end

      if inside_drawer
        raise ParseError.new("File ended without closing property drawer with :END:", lines.length)
      end

      new(keywords, nodes)
    end
  end

  class Node
    attr_reader :level, :title, :properties, :content, :children, :line_number
    attr_accessor :parent

    def initialize(level, title, line_number)
      @level = level
      @title = title
      @line_number = line_number
      @properties = {}
      @content = []
      @children = []
      @parent = nil
    end

    def find_child(title)
      @children.find { |c| c.title == title }
    end
  end

  class ListItem
    attr_reader :label, :value, :line_number

    def initialize(label, value, line_number)
      @label = label
      @value = value
      @line_number = line_number
    end

    def append_continuation(text)
      @value = "#{@value} #{text}"
    end
  end
end
