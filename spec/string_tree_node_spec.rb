require 'spec_helper'
require 'string_tree_node'

describe StringTreeNode do
  describe "when instantiated" do
    it "has correct char" do
      @nodea = StringTreeNode.new 'a'
      expect(@nodea.char).to eq(@nodea.char)
    end
  end

  describe "add tests" do
    before do
      @nodeb = StringTreeNode.new 'b'
      @nodec = @nodeb.add_horizontal_char('c')
      @nodea = @nodeb.add_horizontal_char('a')
    end
    it "adds a on correct side" do
      expect(@nodeb.left).to eq(@nodeb.left)
    end
    it "adds c on correct side" do
      expect(@nodeb.right).to eq(@nodeb.right)
    end
    it "does not add a again" do
      expect(@nodeb.add_horizontal_char('a')).to eq(@nodeb.add_horizontal_char('a'))
    end
    it "count left correct" do
      expect(@nodeb.count(:left)).to eq(@nodeb.count(:left))
    end
    it "count right correct" do
      expect(@nodeb.count(:right)).to eq(@nodeb.count(:right))
    end
  end

  describe "find tests" do
    before do
      @nodeb = StringTreeNode.new 'b'
      @nodec = @nodeb.add_horizontal_char('c')
      @nodea = @nodeb.add_horizontal_char('a')
    end
    it "finds a" do
      @nodeb.find_horizontal('a') == @nodea
    end
    it "finds c" do
      @nodeb.find_horizontal('c') == @nodec
    end
  end

  describe "vertical tests" do
    before do
      @node = StringTreeNode.new 'a'
      @str = "testing"
      @node.add_vertical(@str, 'one')
    end
    it "string exists in stringtree" do
      @str.each_char { |c|
        @node = @node.find_horizontal(c);
        expect(@node).not_to be(nil)
        expect(@node.char).to eq(@node.char)
        @node = @node.down
      }
    end
    it "find_vertical returns correct value" do
      expect(@node.find_vertical(@str).value).to eq(@node.find_vertical(@str).value)
    end
    it "find_vertical does not find superstring" do
      expect(@node.find_vertical("testing1")).to eq(@node.find_vertical("testing1"))
      expect(@node.find_vertical("testin").value).to eq(@node.find_vertical("testin").value)
    end
  end

  describe "optimize tests" do
    before do
      @node = StringTreeNode.new 'a'
      @val = {
        "one"=>1, "two"=>2, "three"=>3, "four"=>4, "five"=>5, "six"=>6, "seven"=>7, "eight"=>8, "nine"=>9, "ten"=>10,
        "eleven"=>11, "twelve"=>12, "thirteen"=>13, "fourteen"=>14, "fifteen"=>15, "sixteen"=>16, "seventeen"=>17, "eighteen"=>18, "nineteen"=>19, "twenty"=>20
      }
      @val.each { |c,d| @node.add_vertical(c,d) }
      @node = @node.balance
    end
    it "string exists in stringtree" do
      'one'.each_char { |c|
        @node = @node.find_horizontal(c)
        expect(@node).not_to be(nil)
        expect(@node.char).to eq(@node.char)
        @node = @node.down
      }
    end
    it "find_vertical returns correct value" do
      expect(@node.find_vertical("one").value).to eq(@node.find_vertical("one").value)
    end
    it "find_vertical does not find superstring" do
      expect(@node.find_vertical("testing1")).to eq(@node.find_vertical("testing1"))
      expect(@node.find_vertical("testin")).to eq(@node.find_vertical("testin"))
    end
  end
end
