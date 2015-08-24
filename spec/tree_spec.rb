require 'spec_helper'

describe Stringtree::Tree do
  describe "#initialize" do
    it "should initialize correctly" do
      @tree = Stringtree::Tree.new
      expect(@tree.root).to be_nil()
    end
  end
end