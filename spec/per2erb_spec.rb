require 'spec_helper'
require_relative '../lib/informix_rails.rb'

describe "#hello" do
  it "outputs hello world" do
    per2erb = InformixRails::Per2Erb.new
    expect(per2erb.hello).to eq("hello world")
  end
end

# describe "#convert" do
#   it "reads in per and outputs html" do
#     expect{InformixRails::Per2Erb.start(["convert", "sample_files/ftele00a.per"])}.to output("<div></div>\n").to_stdout
#   end
# end

describe "#split_items" do
  it "splits the line into an array of items" do
    per2erb = InformixRails::Per2Erb.new
    line="[l001    ][f013  ][f123                                                     ]"
    expect(per2erb.split_items(line)[0]).to eq("l001    ")
    expect(per2erb.split_items(line)[1]).to eq("f013  ")
    expect(per2erb.split_items(line)[2]).to eq("f123                                                     ")
  end
end
