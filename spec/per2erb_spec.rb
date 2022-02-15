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
      erb = "<div></div>"\
        "\n"

      expect{InformixRails::Per2Erb.start(["convert", "sample_files/ftele00a.per"])}.to output(erb).to_stdout
    end
  end

  describe "#split_items" do
    it "splits the line into an array of items" do
      line="[l001    ][f013  ][f123                                                     ]"
      expect(@per2erb.split_items(line)[0]).to eq("l001    ")
      expect(@per2erb.split_items(line)[1]).to eq("f013  ")
      expect(@per2erb.split_items(line)[2]).to eq("f123                                                     ")
    end
  end

  describe "#convert_label" do
    describe "passing in a label" do
      it "outputs erb" do
        expect(@per2erb.convert_label("l001   ")).to eq("<%= form.label :l001, 'l001', class: 'flex-label' %>")
      end
    end

    describe "passing in a text field" do
      it "outputs nil" do

      end
    end
  end

  describe "#detect_size" do
    describe "pass in small item" do
      it "returns flex-label" do
        expect(@per2erb.detect_size("l001   ")).to eq("flex-label")
      end
    end

    describe "pass in medium item" do
      it "returns flex-label-m" do
        expect(@per2erb.detect_size("l001       ")).to eq("flex-label-m")
      end
    end

    describe "pass in large item" do
      it "returns flex-label-l" do
        expect(@per2erb.detect_size("l001           ")).to eq("flex-label-l")
      end
    end
  end

end
