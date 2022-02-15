require 'spec_helper'
require_relative '../lib/informix_rails.rb'

describe "Per2Erb" do
  before do
    @per2erb = InformixRails::Per2Erb.new
  end

  describe "#hello" do
    it "outputs hello world" do
      expect(@per2erb.hello).to eq("hello world")
    end
  end

  describe "#convert" do
    it "outputs erb" do
      output="<div class='flex-container'>\n"\
          "  <%= form.label :l001, 'l001', class: 'flex-label-m' %>\n"\
          "</div>\n\n"

      expect{InformixRails::Per2Erb.start(["convert", "sample_files/simple.per"])}.to output(output).to_stdout
    end
  end

  describe "#build_erb" do
    it "builds the whole erb" do
        output="<div class='flex-container'>\n"\
          "  <%= form.label :l001, 'l001', class: 'flex-label-m' %>\n"\
          "</div>\n\n"

        expect(@per2erb.build_erb("sample_files/simple.per")).to eq(output)
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

  describe "#wrap_container" do
    describe "given a contents with one label" do
      it "wraps it with a flex-container" do
        output="<div class='flex-container'>\n"\
          "  test\n"\
          "</div>\n\n"
        expect(@per2erb.wrap_content("  test")).to eq(output)
      end
    end
  end

  describe "#convert_line" do

    describe "given label + 2 text fields" do
      it "creates labels and fields" do
        line="[l001    ][f013  ][f123                                                     ]"
        output="<div class='flex-container'>\n"\
          "  <%= form.label :l001, 'l001', class: 'flex-label-m' %>\n"\
          "  <%= form.text_field :f013, class: 'flex-s', disabled: @show %>\n"\
          "  <%= form.text_field :f123, class: 'flex-l-g', disabled: @show %>\n"\
          "</div>\n\n"
        expect(@per2erb.convert_line(line)).to eq(output)
      end
    end

    describe "labels and fields with text inbetween" do
      it "keeps the labels" do
        line="[l001    ][f013  ]test[f123                                                 ]"
        output="<div class='flex-container'>\n"\
          "  <%= form.label :l001, 'l001', class: 'flex-label-m' %>\n"\
          "  <%= form.text_field :f013, class: 'flex-s', disabled: @show %>\n"\
          "  test\n"\
          "  <%= form.text_field :f123, class: 'flex-l-g', disabled: @show %>\n"\
          "</div>\n\n"
        expect(@per2erb.convert_line(line)).to eq(output)
      end
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
