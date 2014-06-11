require 'spec_helper'
require 'string_tree_item'

describe StringTreeItem do
  describe "#initalize" do
    it "should initialize correctly" do
      @nodea = StringTreeItem.new(1,2,3)
      expect(@nodea.offset).to eq(1)
      expect(@nodea.match).to eq(2)
      expect(@nodea.node).to eq(3)
    end
  end

  describe "#match?" do
    it "should return @match" do
      @nodea = StringTreeItem.new(1,2,3)
      expect(@nodea.match?).to eq(2)
    end
  end
end