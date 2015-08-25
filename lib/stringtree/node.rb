module StringTree
  # Node represents a node in a StringTree::Tree. 
  #
  # This is essentially a binary tree node with additional up and down pointers.
  class Node
    # The char Character value of this node
    attr_accessor :char
    # The next left node to this node, or nil
    attr_accessor :left
    # The next right node to this node, or nil
    attr_accessor :right
    # The child (down) node of this node, or nil
    attr_accessor :down
    # The parent (up) node to this node, or nil
    attr_accessor :up
    # The value of this node, or nil
    attr_accessor :value

    # Create a new Node with the given char and optionally, parent node and value
    def initialize(char, parent = nil, value = nil)
      @char = char
      @up = parent
      @value = value
    end

    # Add another node horizontally
    # (within the left-right binary tree of this Node)
    def add_horizontal(node)
      if(node.char > @char)
        if (@right === nil)
          @right = node
        else
          @right.add_horizontal(node)
        end
      else
        if (@left === nil)
          @left = node
        else
          @left.add_horizontal(node)
        end
      end
    end

    # Add and return a new, or return the existing, node with the given char horizontally
    # (within the left-right binary tree of this Node)
    def add_horizontal_char(char)
      node = find_horizontal(char);
      if node != nil
        return node
      end
      node = Node.new(char, up)
      add_horizontal(node)
      return node
    end

    # Find and return the node corresponding to the given char horizontally, or nil if not found
    # (within the left-right binary tree of this Node)
    def find_horizontal(char)
      return self if @char == char
      if(char > @char)
        if (@right === nil)
          return nil
        else
          return @right.find_horizontal(char)
        end
      else
        if (@left === nil)
          return nil
        else
          return @left.find_horizontal(char)
        end
      end
    end

    # Add the given String str and value vertically to this node, by adding or finding each character 
    # horizontally, then stepping down and repeating with the next character and so on, writing the 
    # value to the last node.
    def add_vertical(str, value)
      node = nil
      str.each_char { |c|
        if (node == nil)
          node = self.add_horizontal_char(c)
        elsif (node.down != nil)
          node = node.down.add_horizontal_char(c)
        else
          node.down = Node.new(c, node)
          node = node.down
        end
      }
      node.value = value
    end

    # Find the given String str vertically by finding each character horizontally, then stepping down 
    # and repeating with the next character and so on. Return the last node if found, or nil if any
    # horizontal search fails. 
    # Optionally, set the offset into the string and its length
    def find_vertical(str, offset = 0, length = str.length)
      node = nil
      i = offset
      while (i<offset+length)
        c = str[i]
        if (node == nil)
          node = self.find_horizontal(c)
        elsif (node.down != nil)
          node = node.down.find_horizontal(c)
        else
          return nil
        end

        return nil if (node == nil)
        i += 1
      end
      node
    end

    # Find the next match (terminating node with value non-nil) in the String data
    # Optionally, set the offset into the data and its length
    def find_forward(data, offset = 0, length = data.length)
      node = nil
      lastvaluenode = nil
      i = offset
      while (i<offset+length)
        c = data[i]
        if (node == nil)
          node = self.find_horizontal(c)
        elsif (node.down != nil)
          node = node.down.find_horizontal(c)
        else
          return lastvaluenode
        end
        return lastvaluenode  if (node == nil)
        lastvaluenode = node if (node.value != nil)
        i += 1
      end
      lastvaluenode
    end

    # Count the number of nodes in the given direction (:up,:down,:left,:right) until
    # the edge of the tree.
    def count(direction)
      i = 0
      node = self
      while (node != nil)
        node = node.send(direction)
        i += 1
      end
      i
    end

    # Recursively balance this node in its own tree, and every node in all four directions,
    # and return the new root node.
    def balance
      node = self
      i = (node.count(:right) - node.count(:left))/2
      while (i!=0)
        if (i>0)
          mvnode = node.right
          node.right = nil
          mvnode.add_horizontal node
          i -= 1
        else
          mvnode = node.left
          node.left = nil
          mvnode.add_horizontal node
          i += 1
        end
        node = mvnode
      end
      if (node.left != nil)
        node.left = node.left.balance
      end
      if (node.right != nil)
        node.right = node.right.balance
      end
      if (node.down != nil)
        node.down = node.down.balance
      end
      node
    end

    # Walk the tree from this node, yielding all strings and values where the
    # value is not nil. Optionally, use the given prefix String str.
    def walk(str="", &block)
      @down.walk(str+char, &block) if @down != nil
      @left.walk(str, &block) if @left != nil
      yield str+@char, @value if @value != nil
      @right.walk(str, &block) if @right != nil
    end

    # Return the complete string from the tree root up to and including this node
    # i.e. The total string key for this node from root.
    def to_s
      st = @char
      node = self
      while node != nil
        node = node.up
        break if node==nil
        st = node.char+st
      end
      st
    end

    # Return the length of the total string key for this node from root.
    def length
      count(:up)
    end

    # Return an Array of Strings of all possible partial string from this node.
    # Optionally, use the given prefix String str.
    def all_partials(str = "")
      list = []      
      @down.walk(str) { |str| list << str } unless @down.nil?
      list
    end
  end
end
