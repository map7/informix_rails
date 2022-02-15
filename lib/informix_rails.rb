# frozen_string_literal: true

require_relative "informix_rails/version"
require "thor"

module InformixRails
  class Error < StandardError; end

  class Per2Erb < Thor

    desc "convert [file]", "Convert per to erb"
    def convert(file)

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

      puts "<div></div>"
    end

    def hello
      "hello world"
    end
  end

end
