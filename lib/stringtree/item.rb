module StringTree
  # Represents an individual tokenized item in a dataset, i.e. A match, its offset and its terminator node
  class Item
    # The offset of the Item in the dataset, in chars
    attr_accessor :offset
    # The match itself
    attr_accessor :match
    # The terminating node of the match.
    attr_accessor :node

    # Create a new Item with the specifid offset,match and optionally, node.
    def initialize(offset, match, node = nil)
      @offset = offset
      @match = match
      @node = node
    end

    # Returns true if this is a match.
    def match?
      @match
    end

    # Returns the value of the match if not nil
    def value
      @node.value unless @node.nil?
    end
  end
end