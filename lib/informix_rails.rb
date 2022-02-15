# frozen_string_literal: true

require_relative "informix_rails/version"
require "thor"

module InformixRails
  class Error < StandardError; end

  class Per2Erb < Thor

    desc "convert [file]", "Convert per to erb"
    def convert(file)
      puts build_erb(file)
    end

    no_commands{

      def build_erb(file)
        output = read(file)

        content = ""
        output.each do |line|
          content += convert_line(line) unless line.strip.empty?
        end
        content
      end

      def read(file)
        output = []
        @read = false

        File.foreach(file) do |line|
          break if line[0] == "}"
          if line[0] == "{"
            @read=true
            next
          end

          if @read
            output << line
          end
        end
        output
      end

      def remove_before(token,items)
        @remove = true
        items.delete_if {|x|
          @remove = false if x == token
          @remove || x == token
        }
      end

      def remove_after(token,items)
        items.delete_if {|x|
          @remove = true if x == token
          @remove || x == token
        }
      end

      def wrap_content(content)
        "<div class='flex-container'>\n#{content}\n</div>\n\n"
      end

      def convert_line(line)
        content = split_items(line).map{ |item|
          convert_item(item)}.join("\n")
        wrap_content(content)
      end

      def split_items(line)
        results = []
        skip = 0
        items = (line.split(/([\[\]])/).reject{|c| c.strip.empty?})
        items.each_with_index do |item,i|

          if item == '['
            skip = 2
            results << items[i] + items[i+1] + items[i+2]

          elsif skip > 0
            skip -= 1
            next

          else
            results << item
          end
        end
        return results

      end

      def convert_item(item)
        if item[0..1] == '[l'
          size = detect_label_size(item)
          name = item.split(/([\[\]])/)[2].strip
          return "  <%= form.label :#{name}, '#{name}', class: '#{size}' %>"
        elsif item[0] == '['
          size = detect_field_size(item)
          name = item.split(/([\[\]])/)[2].strip
          return "  <%= form.text_field :#{name}, class: '#{size}', disabled: @show %>"
        else
          return "  #{item.strip}"
        end
      end

      def detect_label_size(item)
        if item.size < 10
          size=""
        elsif item.size < 14
          size="-m"
        elsif item.size < 18
          size="-l"
        end

        "flex-label#{size}"
      end

      def detect_field_size(item)
        if item.size < 10
          size="-s"
        elsif item.size < 14
          size="-m"
        elsif item.size < 18
          size="-l"
        else
          size="-l-g"
        end

        "flex#{size}"
      end
    }
  end
end
