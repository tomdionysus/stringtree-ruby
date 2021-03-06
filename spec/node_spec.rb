require 'spec_helper'

describe StringTree::Node do
  describe "when instantiated" do
    it "has correct char" do
      @nodea = StringTree::Node.new 'a'
      expect(@nodea.char).to eq(@nodea.char)
    end
  end

  describe "add tests" do
    before do
      @nodeb = StringTree::Node.new 'b'
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
      @nodeb = StringTree::Node.new 'b'
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
      @node = StringTree::Node.new 'a'
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
      @node = StringTree::Node.new 'a'
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

  describe '#walk' do
    it 'should walk a tree correctly' do
      inst = StringTree::Node.new 'b'
      inst.left = StringTree::Node.new 'a'
      inst.right = StringTree::Node.new 'c'
      inst.down = StringTree::Node.new '2'
      inst.down.left = StringTree::Node.new '1'
      inst.down.right = StringTree::Node.new '3'

      list = []
      inst.walk do |k,v|
        puts k,v
        list << { k => v }
      end
      expect(list).to eq []
    end

  end

  describe '#all_partials' do
    it 'should call @down.walk if it exists' do

      inst = StringTree::Node.new 'a'
      inst.down = StringTree::Node.new 'b'

      expect(inst.down).to receive(:walk).with('one')
      inst.all_partials('one')
    end

    it 'should not call @down.walk if it doesnt exist' do
      # Spec will fail with exception if faulty.
      inst = StringTree::Node.new 'a'
      inst.down = nil
      inst.all_partials('one')
    end
  end

  describe '#find_forward' do
    it 'should return the correct node' do

      inst = StringTree::Node.new 'b'
      inst.left = StringTree::Node.new 'a'
      inst.right = StringTree::Node.new 'c'
      inst.down = StringTree::Node.new '2', inst, 'one'
      inst.down.left = StringTree::Node.new '1', inst
      inst.down.right = StringTree::Node.new '3', inst

      expect(inst.find_forward("b2",0,2)).to be(inst.down)
      expect(inst.find_forward("asoicbasicn",0,2)).to be_nil
    end
  end

  describe '#to_s' do
    it 'should return the correct string' do
      inst = StringTree::Node.new 'b'
      inst.left = StringTree::Node.new 'a'
      inst.right = StringTree::Node.new 'c'
      inst.down = StringTree::Node.new '2', inst, 'one'
      inst.down.left = StringTree::Node.new '1', inst
      inst.down.right = StringTree::Node.new '3', inst

      expect(inst.down.left.to_s).to eq("b1")
      expect(inst.down.right.to_s).to eq("b3")
      expect(inst.down.to_s).to eq("b2")
      expect(inst.right.to_s).to eq("c")
      expect(inst.left.to_s).to eq("a")
      expect(inst.to_s).to eq("b")
    end
  end

  describe '#length' do
    it 'should return the correct count' do
      inst = StringTree::Node.new 'b'
      inst.left = StringTree::Node.new 'a'
      inst.right = StringTree::Node.new 'c'
      inst.down = StringTree::Node.new '2', inst, 'one'
      inst.down.left = StringTree::Node.new '1', inst
      inst.down.right = StringTree::Node.new '3', inst
      inst.down.left.down = StringTree::Node.new 'z', inst.down.left
      inst.down.left.down.left = StringTree::Node.new 'v', inst.down.left

      expect(inst.down.left.down.left.length).to eq(3)
      expect(inst.down.left.down.length).to eq(3)
      expect(inst.down.left.length).to eq(2)
      expect(inst.down.length).to eq(2)
      expect(inst.length).to eq(1)
    end
  end

end
