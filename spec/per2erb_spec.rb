require 'spec_helper'
require_relative '../lib/informix_rails.rb'

describe "#hello" do
  it "outputs hello world" do
    expect(InformixRails::Per2Erb.start(["hello"])).to eq("hello world")
  end
end
