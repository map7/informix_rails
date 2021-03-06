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
        wrap_content(content)
      end

      def read(file)
        output = File.read(file).split("\n")
        output = crop("{","}",output)
        output.reject!(&:empty?)
        output
      end

      def crop(before,after,items)
        items = remove_before("{",items)
        items = remove_after("}",items)
        items
      end

      def remove_before(token,items)
        remove(token,items) {|found| !found}
      end

      def remove_after(token,items)
        remove(token,items) {|found| found}
      end

      def remove(token,items)
        found = false
        items.delete_if {|x|
          found = true if x == token
          yield(found) || x == token
        }
      end

      def wrap_content(content)
        content = add_actions(content)
        content = wrap_box(content)
        content = wrap_form(content)
        content
      end

      def wrap_container(content)
        "<div class='flex-container'>\n"\
          "#{content}\n"\
          "</div>\n\n"
      end

      def wrap_form(content)
        "<%= form_with(model: @model, html: {autocomplete: 'off'}) do |form| %>\n"\
          "#{content}"\
          "<% end %>\n"
      end

      def wrap_box(content)
        "<div class='one_box'>\n"\
          "#{content}"\
          "</div>\n"
      end

      def add_actions(content)
        "#{content}"\
          "<div class='item_actions'>\n"\
      "Option:\n"\
      "<span class='links'>\n"\
      "Add\nEd\nDel\nNx\nPr\nFd\nVw\n"\
      "<%= link_to_kb 'X', '/menus/main', ['x','f7']  %>\n"\
      "<%= form.submit 'OK[F11]', id: 'ok', 'data-reset_form-target':'button' %>\n"\
      "</span>\n"\
      "</div>\n"
      end

      def convert_line(line)
        content = split_items(line).map{ |item|
          convert_item(item)}.join("\n")
        wrap_container(content)
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
        if item.size < 4
          size="-xxs"
        elsif item.size < 7
          size="-xs"
        elsif item.size < 10
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
