require 'spec_helper'

describe StringTree::Tree do
  describe "#initialize" do
    it "should initialize correctly" do
      @tree = StringTree::Tree.new
      expect(@tree.root).to be_nil()
    end
  end

  describe '#add' do
    it 'should produce the correct node tree' do
      inst = StringTree::Tree.new

      inst.add("OneX",5)
      inst.add("TwoX",3)
      inst.add("TenX",10)

      expect(inst.root.char).to eq("O")
      expect(inst.root.right.char).to eq("T")
      expect(inst.root.left).to be_nil()
      expect(inst.root.right.down.char).to eq("w")
      expect(inst.root.right.down.left.char).to eq("e")
      expect(inst.root.right.down.right).to be_nil()
    end

    it 'should overwrite value if key exists' do
      inst = StringTree::Tree.new

      inst.add("OneX",5)
      inst.add("TwoX",3)
      inst.add("TenX",10)

      expect(inst.find("TenX")).to eq(10)

      inst.add("TenX",15)
      expect(inst.find("TenX")).to eq(15)
    end
  end

  describe '#find' do
    it 'should return nil if tree empty' do
      inst = StringTree::Tree.new

      expect(inst.find("TwoX")).to be_nil()
    end

    it 'should return correct value' do
      inst = StringTree::Tree.new

      inst.add("OneX",5)
      inst.add("TwoX",3)
      inst.add("TenX",10)

      expect(inst.find("TwoX")).to eq(3)
    end

    it 'should return nil if not found' do
      inst = StringTree::Tree.new

      inst.add("OneX",5)
      inst.add("TwoX",3)
      inst.add("TenX",10)

      expect(inst.find("FiveX")).to be_nil()
      expect(inst.find("O")).to be_nil()
    end
  end

  describe '#has_key?' do
    it 'should return false if tree empty' do
      inst = StringTree::Tree.new
      expect(inst.has_key?("TwoX")).to be(false)
    end

    it 'should return correct results if found' do
      inst = StringTree::Tree.new

      inst.add("OneX",5)
      inst.add("TwoX",3)
      inst.add("TenX",10)

      expect(inst.has_key?("OneX")).to be(true)
      expect(inst.has_key?("TwoX")).to be(true)
      expect(inst.has_key?("TenX")).to be(true)
      expect(inst.has_key?("O")).to be(false)
      expect(inst.has_key?("Two")).to be(false)
      expect(inst.has_key?("OTwo")).to be(false)
      expect(inst.has_key?("OneXX")).to be(false)
    end

    describe '#partials' do
      it 'should return correct results if found' do
        inst = StringTree::Tree.new
        inst.add('ant',1)
        inst.add('antler',2)
        inst.add('deer',3)
        inst.add('anthropic',4)
        inst.add('beer',5)

        expect(inst.partials('ant')).to eq(["antler", "anthropic"])
        expect(inst.partials('be')).to eq(["beer"])
        expect(inst.partials('d')).to eq(["deer"])
        expect(inst.partials('a')).to eq(["antler", "anthropic", "ant"])
      end
    end

    describe '#optimize!' do
      it 'should balance nodes' do
        inst = StringTree::Tree.new
        inst.add('abaft',2)
        inst.add('abalone',3)
        inst.add('abandon',4)
        inst.add('abandoned',5)
        inst.add('mystagogue',6)
        inst.add('mystagogy',7)
        inst.add('mysteries',8)
        inst.add('mysterious',9)
        inst.add('zestful',10)
        inst.add('zestfully',11)
        inst.add('zestfulness',12)
        inst.add('zesty',13)

        expect(inst.root.char).to eq('a')
        expect(inst.root.count(:left)).to eq(1)
        expect(inst.root.count(:right)).to eq(3)
        expect(inst.root.down.char).to eq('b')
        expect(inst.root.down.count(:left)).to eq(1)
        expect(inst.root.down.count(:right)).to eq(1)
        expect(inst.root.down.down.char).to eq('a')
        expect(inst.root.down.down.count(:left)).to eq(1)
        expect(inst.root.down.down.count(:right)).to eq(1)

        inst.optimize!

        expect(inst.root.char).to eq('m')
        expect(inst.root.count(:left)).to eq(2)
        expect(inst.root.count(:right)).to eq(2)
        expect(inst.root.down.char).to eq('y')
        expect(inst.root.down.count(:left)).to eq(1)
        expect(inst.root.down.count(:right)).to eq(1)
        expect(inst.root.down.down.char).to eq('s')
        expect(inst.root.down.down.count(:left)).to eq(1)
        expect(inst.root.down.down.count(:right)).to eq(1)
      end

      it 'should not disturb normal behaviour' do
        inst = StringTree::Tree.new

        inst.add("OneX",5)
        inst.add("TwoX",3)
        inst.add("TenX",10)
        inst.add("FifteenX",15)

        inst.optimize!

        expect(inst.find("OneX")).to eq(5)
        expect(inst.find("TwoX")).to eq(3)
        expect(inst.find("TenX")).to eq(10)
        expect(inst.find("FifteenX")).to eq(15)
        expect(inst.find("FiveX")).to be_nil()
        expect(inst.find("O")).to be_nil()
      end
    end

    describe '#match_all' do
      it 'should tokenize properly' do

        inst = StringTree::Tree.new
        inst.add('test',1)
        inst.add('foo',2)
        inst.add('bar',3)

        x = []
        inst.match_all('the testing of foo should be bar for foo') { |match| x << match }

        expect(x.length).to eq(4)
        expect([x[0].offset,x[0].node.to_s,x[0].node.value]).to eq([4,'test',1])
        expect([x[1].offset,x[1].node.to_s,x[1].node.value]).to eq([15,'foo',2])
        expect([x[2].offset,x[2].node.to_s,x[2].node.value]).to eq([29,'bar',3])
        expect([x[3].offset,x[3].node.to_s,x[3].node.value]).to eq([37,'foo',2])
      end
    end

    describe '#[]' do
      it 'should return nil if tree empty' do
        inst = StringTree::Tree.new

        expect(inst["TwoX"]).to be_nil()
      end

      it 'should return like find' do
        inst = StringTree::Tree.new

        inst.add("OneX",5)
        inst.add("TwoX",3)
        inst.add("TenX",10)

        expect(inst["TwoX"]).to eq(3)
      end

      it 'should return nil if not found' do
        inst = StringTree::Tree.new

        inst.add("OneX",5)
        inst.add("TwoX",3)
        inst.add("TenX",10)

        expect(inst["FiveX"]).to be_nil()
        expect(inst["O"]).to be_nil()
      end
    end

    describe '#[]=]' do
      it 'should produce the correct node tree like add' do
        inst = StringTree::Tree.new

        inst["OneX"] = 5
        inst["TwoX"] = 3
        inst["TenX"] = 10

        expect(inst.root.char).to eq("O")
        expect(inst.root.right.char).to eq("T")
        expect(inst.root.left).to be_nil()
        expect(inst.root.right.down.char).to eq("w")
        expect(inst.root.right.down.left.char).to eq("e")
        expect(inst.root.right.down.right).to be_nil()
      end

      it 'should overwrite value if key exists' do
        inst = StringTree::Tree.new

        inst["OneX"] = 5
        inst["TwoX"] = 3
        inst["TenX"] = 10

        expect(inst.find("TenX")).to eq(10)

        inst.add("TenX",15)
        expect(inst.find("TenX")).to eq(15)
      end
    end

    describe '#match_count' do
      it 'should count properly' do

        arr = {
          "test"=>1,
          "foo"=>2,
          "bar"=>3,
        }
        inst = StringTree::Tree.new

        arr.each do |k,v|
          inst.add(k,v)
        end

        x = inst.match_count('the testing of foo should be bar for foo')

        x.each do |k,v|
          expect(k.value).to eq(arr[k.to_s])
        end
      end
    end
  end
end