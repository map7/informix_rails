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

        File.open(file, 'r') do |file|

          @read = false

          file.readlines.each do |line|
            if line[0] == "{"
              @read=true
              next
            elsif line[0] == "}"
              @read=false
            end

            if @read
              output << line
            end
          end
        end
        output
      end

      def wrap_content(content)
        "<div class='flex-container'>\n#{content}\n</div>\n"
      end

      def convert_line(line)
        content = split_items(line).map{ |item|
          convert_item(item)}.join("\n")
        wrap_content(content)
      end

      def split_items(line)
        line.split(/\[(.*?)\]/).reject{|c| c.strip.empty?}
      end

      def convert_item(item)
        if item[0] == 'l'
          size = detect_label_size(item)
          return "<%= form.label :#{item.strip}, '#{item.strip}', class: '#{size}' %>"
        elsif item[0] == 'f'
          size = detect_field_size(item)
          return "<%= form.text_field :#{item.strip}, class: '#{size}', disabled: @show %>"
        else
          return "#{item.strip}"
        end
      end

      def detect_label_size(item)
        if item.size < 8
          size=""
        elsif item.size < 12
          size="-m"
        elsif item.size < 16
          size="-l"
        end

        "flex-label#{size}"
      end

      def detect_field_size(item)
        if item.size < 8
          size="-s"
        elsif item.size < 12
          size="-m"
        elsif item.size < 16
          size="-l"
        else
          size="-l-g"
        end

        "flex#{size}"
      end

      def hello
        "hello world"
      end

    }
    end
end
