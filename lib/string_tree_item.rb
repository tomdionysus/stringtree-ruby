class StringTreeItem
  attr_accessor :offset,:match,:node
  def initialize(offset, match, node = nil)
    @offset = offset
    @match = match
    @node = node
  end
  
  def match?
    @match
  end
end