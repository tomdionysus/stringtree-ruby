require 'spec_helper'

describe StringTree::Tree do
  describe "#initialize" do
    it "should initialize correctly" do
      @tree = StringTree::Tree.new
      expect(@tree.root).to be_nil()
    end
  end
end