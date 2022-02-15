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
