class StringTreeNode
  attr_accessor :char, :left, :right, :down, :up, :value
  def initialize(char, parent = nil)
    @char = char
    @up = parent
  end

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

  def add_horizontal_char(char)
    node = find_horizontal(char);
    if node != nil
      return node
    end
    node = StringTreeNode.new(char, up)
    add_horizontal(node)
    return node
  end

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

  def add_vertical(str, value)
    node = nil
    str.each_char { |c|
      if (node == nil)
        node = self.add_horizontal_char(c)
      elsif (node.down != nil)
        node = node.down.add_horizontal_char(c)
      else
        node.down = StringTreeNode.new(c, node)
        node = node.down
      end
    }
    node.value = value
  end

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

  def find_forward(str, offset = 0, length = str.length)
    node = nil
    lastvaluenode = nil
    i = offset
    while (i<offset+length)
      c = str[i]
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

  def count(direction)
    i = 0
    node = self
    while (node != nil)
      node = node.send(direction)
      i += 1
    end
    i
  end

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

  def walk(list, str="")

    list << { :key => str+@char, :value => @value }  if (@value != nil)
    @down.walk(list, str+char) if @down!=nil
    @left.walk(list, str) if @left!=nil
    @right.walk(list, str) if @right!=nil
  end

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

  def all_partials(str)
    list = []
    @down.walk(list, str) unless @down.nil?
    list
  end
end
