require 'spec_helper'
require 'string_tree'

describe StringTree do
  describe "#initialize" do
    it "should initialize correctly" do
      @tree = StringTree.new
      expect(@tree.root).to be_nil()
    end
  end
end