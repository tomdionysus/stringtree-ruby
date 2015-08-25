module StringTree
  # Tree represents a complete StringTree, and has functionality resembling a Hash.
  class Tree
    # The root StringTree::Node, or nil if empty
    attr_accessor :root
    
    # Create a new empty Tree
    def initialize
      clear
    end

    # Add a key and value to this Tree
    def add(key,value)
      @root = Node.new(key[0], nil) if (@root == nil)
      @root.add_vertical(key,value)
    end

    alias []= add

    # Clear the Tree (Remove all keys/values)
    def clear
      @root = nil
    end

    # Find a specified key in the Tree, and return the value, or nil if not found.
    def find(key)
      node = find_node(key)
      (node == nil ? nil : node.value)
    end

    alias [] find

    # Return true if the given key exists
    def has_key?(key)
      !find_node(key).nil?
    end

    alias include? has_key?

    # Delete a key 
    def delete(key)
      node = find_node(key) 
      return false if node.nil?
      node.value = nil
      node.prune
      true
    end

    # Return an Array of Strings representing all partial matches forward of key in the Tree.
    # Please note the key itself is not included, even if it exists as a value.
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
    def optimize!
      return nil if @root == nil
      @root.prune
      @root = @root.balance
    end

    # Tokenize the string Data by finding all instances of any key in the Tree.
    # yields each instance as a StringTree::Item.
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

    # Return a Hash of terminating nodes to Integer counts for a given String data,
    # i.e. Find the count of instances of each String in the tree in the given data.
    def match_count(data, list = {})
      return nil if @root == nil
      i=0
      while (i<data.length)
        node = @root.find_forward(data, i, data.length-i)
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

    private

    # Find a node by its key
    def find_node(key)
      return nil if @root == nil
      node = @root.find_vertical(key)
      (node.nil? || node.value.nil? ? nil : node)
    end
  end
end
