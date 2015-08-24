module Stringtree
  class Tree
    attr_accessor :root
    def initialize()
      @root = nil
    end

    def add(str,value)
      @root = Node.new(str[0], nil) if (@root == nil)
      @root.add_vertical(str,value)
    end

    def find(str)
      return nil if @root == nil
      node = @root.find_vertical(str)
      (node == nil ? nil : node.value)
    end

    def partials(str)
      return nil if @root == nil
      node = @root.find_vertical(str)
      return nil if node == nil
      node.all_partials(str)
    end

    def optimize
      return nil if @root == nil
      @root = @root.balance
    end

    def match_all(str, &block)
      return nil if @root == nil
      i=0
      while (i<str.length)
        node = @root.find_forward(str, i, str.length-i)
        if (node!=nil && node.value!=nil)
          yield Item.new(i, true, node)
          i += node.length
        else
          i += 1
        end
      end
    end

    def [](key)
      find(key)
    end

    def []=(key,value)
      add(key,value)
    end

    def match_count(str,list)
      return nil if @root == nil
      i=0
      while (i<str.length)
        node = @root.find_forward(str, i, str.length-i)
        if (node!=nil && node.value!=nil)
          if (!list.has_key?(node)) 
            list[node] = 1
          else
            list[node] += 1
          end
          i += node.length
        else
          i += 1
        end
      end
      list
    end
  end
end
