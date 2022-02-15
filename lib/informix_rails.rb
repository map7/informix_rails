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

      def convert_label(item)
        size = detect_size(item)
        "<%= form.label :l001, 'l001', class: '#{size}' %>"
      end

      def detect_size(item)
        if item.size < 8
          "flex-label"
        elsif item.size < 12
          "flex-label-m"
        elsif item.size < 16
          "flex-label-l"
        end
      end

      def hello
        "hello world"
      end

    }
    end
end
