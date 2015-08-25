module Stringtree
  # Tree represents a complete Stringtree, and has functionality resembling a Hash.
  class Tree
    # The root Stringtree::Node, or nil if empty
    attr_accessor :root
    
    # Create a new empty Tree
    def initialize
      @root = nil
    end

    # Add a key and value to this Tree
    def add(key,value)
      @root = Node.new(key[0], nil) if (@root == nil)
      @root.add_vertical(key,value)
    end

    # Find a specified key in the Tree, and return the value, or nil if not found.
    def find(key)
      return nil if @root == nil
      node = @root.find_vertical(key)
      (node == nil ? nil : node.value)
    end

    # Return an Array of Strings representing all partial matches forward of key in the Tree.
    # Please note the key itself, if found, is not included.
    #
    # E.g.: A tree containing 'ant','antler','deer','anthropic','beer'
    # tree.partials('ant') would return ['antler','anthropic']
    def partials(key)
      return nil if @root == nil
      node = @root.find_vertical(key)
      return nil if node == nil
      node.all_partials(key)
    end

    # Rebalance the tree for faster access.
    def optimize
      return nil if @root == nil
      @root = @root.balance
    end

    # Tokenize the string Data by finding all instances of any key in the Tree.
    # yields each instance as a Stringtree::Item.
    def match_all(data, &block)
      return nil if @root == nil
      i=0
      while (i<data.length)
        node = @root.find_forward(data, i, data.length-i)
        if (node!=nil && node.value!=nil)
          yield Item.new(i, true, node)
          i += node.length
        else
          i += 1
        end
      end
    end

    # Alias for find 
    def [](key)
      find(key)
    end

    # Alias for add
    def []=(key,value)
      add(key,value)
    end

    def match_count(key,list)
      return nil if @root == nil
      i=0
      while (i<key.length)
        node = @root.find_forward(key, i, key.length-i)
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
