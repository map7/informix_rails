require 'spec_helper'
require_relative '../lib/informix_rails.rb'

describe "Per2Erb" do
  before do
    @per2erb = InformixRails::Per2Erb.new
    @box_start = "<div class='one_box'>\n"
    @form_start =  "<%= form_with(model: @model, html: {autocomplete: 'off'}) do |form| %>\n"
    @con_start =     "<div class='flex-container'>\n"
    @con_end =       "</div>\n\n"
    @form_end =    "<% end %>\n"
    @actions = "<div class='item_actions'>\n"\
      "Option:\n"\
      "<span class='links'>\n"\
      "Add\nEd\nDel\nNx\nPr\nFd\nVw\n"\
      "<%= link_to_kb 'X', '/menus/main', ['x','f7']  %>\n"\
      "<%= form.submit 'OK[F11]', id: 'ok', 'data-reset_form-target':'button' %>\n"\
      "</span>\n"\
      "</div>\n"
    @box_end =   "</div>\n"
  end

  describe "#convert" do
    it "outputs erb" do
      output=@form_start + @box_start + @con_start +
        "  <%= form.label :l001, 'l001', class: 'flex-label-m' %>\n" +
        @con_end + @actions + @box_end + @form_end

      expect{InformixRails::Per2Erb.start(["convert", "sample_files/simple.per"])}.to output(output).to_stdout
    end
  end

  describe "#build_erb" do
    it "builds the whole erb" do
      output=@form_start + @box_start + @con_start +
        "  <%= form.label :l001, 'l001', class: 'flex-label-m' %>\n" +
        @con_end + @actions + @box_end + @form_end

        expect(@per2erb.build_erb("sample_files/simple.per")).to eq(output)
    end
  end

  describe "#read" do
    it "reads and splits the file" do
      expect(@per2erb.read("sample_files/simple.per")).to eq(["[l001    ]"])
    end
  end

  describe "#crop" do
    it "before {" do
      items = ["database pais", "screen size 24 by 80", "{", "1", "}"]
      expect(@per2erb.crop("{", "}", items)).to eq(["1"])
    end
  end

  describe "#remove_before" do
    it "before {" do
      items = ["database pais", "screen size 24 by 80", "{", "1", "}"]
      expect(@per2erb.remove_before("{", items)).to eq(["1", "}"])
    end
  end

  describe "#remove_after" do
    it "after }" do
      items = ["database", "screen", "{", "1", "}", "foo"]
      expect(@per2erb.remove_after("}", items)).to eq(["database", "screen", "{", "1"])
    end
  end

  describe "#wrap_content" do
    describe "given a contents with one label" do
      it "wraps it with a flex-container" do
        output=@form_start + @box_start + "  test\n" + @actions + @box_end + @form_end
        expect(@per2erb.wrap_content("  test\n")).to eq(output)
      end
    end
  end

  describe "#wrap_container" do
    describe "given a contents with one label" do
      it "wraps it with a flex-container" do
        output="<div class='flex-container'>\n"\
          "  test\n"\
          "</div>\n\n"
        expect(@per2erb.wrap_container("  test")).to eq(output)
      end
    end
  end

  describe "#wrap_form" do
    describe "given some test content" do
      it "wraps it with a form" do
        output=@form_start +
          "  test\n" +
          @form_end
        expect(@per2erb.wrap_form("  test\n")).to eq(output)
      end
    end
  end

  describe "#wrap_box" do
    describe "given some test content" do
      it "wraps it with a div one_box" do
        output=@box_start + "  test\n" + @box_end
        expect(@per2erb.wrap_box("  test\n")).to eq(output)
      end
    end
  end

  describe "#add_actions" do
    describe "given some test content" do
      it "appends actions to then end" do
        output="  test\n" + @actions
        expect(@per2erb.add_actions("  test\n")).to eq(output)
      end
    end
  end

  describe "#convert_line" do

    describe "given label + 2 text fields" do
      it "creates labels and fields" do
        line="[l001    ][f013  ][f123                                                     ]"
        output=@con_start +
          "  <%= form.label :l001, 'l001', class: 'flex-label-m' %>\n"\
          "  <%= form.text_field :f013, class: 'flex-s', disabled: @show %>\n"\
          "  <%= form.text_field :f123, class: 'flex-l-g', disabled: @show %>\n" +
          @con_end
        expect(@per2erb.convert_line(line)).to eq(output)
      end
    end

    describe "labels and fields with text inbetween" do
      it "keeps the labels" do
        line="[l001    ][f013  ]test[f123                                                 ]"
        output=@con_start +
          "  <%= form.label :l001, 'l001', class: 'flex-label-m' %>\n"\
          "  <%= form.text_field :f013, class: 'flex-s', disabled: @show %>\n"\
          "  test\n"\
          "  <%= form.text_field :f123, class: 'flex-l-g', disabled: @show %>\n" +
          @con_end
        expect(@per2erb.convert_line(line)).to eq(output)
      end
    end
  end

  describe "#split_items" do
    it "splits the line into an array of items" do
      line="[l001    ][f013  ]test[f123                                                     ]"
      result = @per2erb.split_items(line)
      expect(result[0]).to eq("[l001    ]")
      expect(result[1]).to eq("[f013  ]")
      expect(result[2]).to eq("test")
      expect(result[3]).to eq("[f123                                                     ]")
    end
  end

  describe "#convert_item" do
    describe "passing in a label" do
      it "outputs erb" do
        expect(@per2erb.convert_item("[l001   ]")).to eq("  <%= form.label :l001, 'l001', class: 'flex-label' %>")
      end
    end

    describe "passing in a text field" do
      it "outputs nil" do
        expect(@per2erb.convert_item("[f013   ]")).to eq("  <%= form.text_field :f013, class: 'flex-s', disabled: @show %>")
      end
    end
  end

  describe "#detect_label_size" do
    describe "pass in small item" do
      it "returns flex-label" do
        expect(@per2erb.detect_label_size("l001   ")).to eq("flex-label")
      end
    end

    describe "pass in medium item" do
      it "returns flex-label-m" do
        expect(@per2erb.detect_label_size("l001       ")).to eq("flex-label-m")
      end
    end

    describe "pass in large item" do
      it "returns flex-label-l" do
        expect(@per2erb.detect_label_size("l001           ")).to eq("flex-label-l")
      end
    end
  end

  describe "#detect_field_size" do
    describe "pass in small item" do
      it "returns flex-s" do
        expect(@per2erb.detect_field_size("f001   ")).to eq("flex-s")
      end
    end

    describe "pass in medium item" do
      it "returns flex-m" do
        expect(@per2erb.detect_field_size("f001       ")).to eq("flex-m")
      end
    end

    describe "pass in large item" do
      it "returns flex-l" do
        expect(@per2erb.detect_field_size("f001           ")).to eq("flex-l")
      end
    end

    describe "pass in very large item" do
      it "returns flex-l" do
        expect(@per2erb.detect_field_size("f001                          ")).to eq("flex-l-g")
      end
    end
  end

end
