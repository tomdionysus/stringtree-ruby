require_relative "string_tree_node"
require_relative "string_tree_item"

class StringTree
  attr_accessor :root
  def initialize()
    @root = nil
  end

  def add(str,value)
    @root = StringTreeNode.new(str[0], nil) if (@root == nil)
    @root.add_vertical(str,value)
  end

  def find(str)
    return nil if @root == nil
    node = @root.find_vertical(str)
    (node == nil ? nil : node.value)
  end

  def find_partial(str)
    return nil if @root == nil
    node = @root.find_vertical(str)
    return nil if node == nil
    node.all_partials(str)
  end

  def optimize
    return nil if @root == nil
    @root = @root.balance
  end

  def match_all(str, list)
    return nil if @root == nil
    i=0
    while (i<str.length)
      node = @root.find_forward(str, i, str.length-i)
      if (node!=nil && node.value!=nil)
        list << StringTreeItem.new(i, true, node)
        i += node.strlength
      else
        i += 1
      end
    end
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
        i += node.strlength
      else
        i += 1
      end
    end
    list
  end
end
