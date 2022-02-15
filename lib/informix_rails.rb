# frozen_string_literal: true

require_relative "informix_rails/version"
require "thor"

module InformixRails
  class Error < StandardError; end

  class Per2Erb < Thor
    desc "convert [file]", "Convert per to erb"
    def convert(file)
      File.open('ftele00a.per', 'r') do |file|

        @read = false

        file.readlines.each do |line|
          if line =~ /screen/
            @read=true
            next
          elsif line =~ /end/
            @read=false
          end

          if @read
            puts line
          end

        end
      end
    end
  end

end
