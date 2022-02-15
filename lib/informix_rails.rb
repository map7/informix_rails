# frozen_string_literal: true

require_relative "informix_rails/version"
require "thor"

module InformixRails
  class Error < StandardError; end

  class Per2Erb < Thor

    desc "convert [file]", "Convert per to erb"
    def convert(file)
      output = read(file)

      puts "<div></div>"
    end

    no_commands{

      def read(file)
        output = []

        File.open('sample_files/ftele00a.per', 'r') do |file|

          @read = false

          file.readlines.each do |line|
            if line =~ /screen/
              @read=true
              next
            elsif line =~ /end/
              @read=false
            end

            if @read
              output << line
            end
          end
        end
        output
      end

      def split_items(line)
        line.gsub(']','').split("[").drop(1)
      end

      def convert_item(item)
        if item[0] == 'l'
          size = detect_label_size(item)
          return "<%= form.label :#{item.strip}, '#{item.strip}', class: '#{size}' %>"
        else
          size = detect_field_size(item)
          return "<%= form.text_field :#{item.strip}, class: '#{size}', disabled: @show %>"
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
        end

        "flex#{size}"
      end

      def hello
        "hello world"
      end

    }
    end
end
