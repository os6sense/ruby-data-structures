require_relative '../BinarySearchTree/binary_search_tree'

# Adds an index to a binary tree via means of the left_size property.
class IndexedNode  < Node
  attr_accessor :left_size
  def initialize(key, value=nil)
    super(key, value)
    @left_size = 0
  end

  # left_size is calculated on insert and causes all parent nodes
  # to recalculate their left_size.
  def insert(node, root=nil, &block)
    return super(node, root) do | inserted_node | 
      inserted_node.update_left_size(nil, 1) unless inserted_node.nil?
      block.call(inserted_node) if block
    end
  end

  # Need to recalculate left_size on deletion
  def delete(node=nil, root=nil, &block)
    return super(node, root) do | dn | 
      block.call(dn) if block
      dn.update_left_size(:deleted, -1) if dn
    end
  end

  # Given an index, return the node at that index. Aliased by []
  def rank(idx_rank)
    return self if idx_rank == left_size
    return left.rank(idx_rank) if idx_rank < left_size 
    return right.rank(idx_rank - left_size - 1) 
  end
  alias [] rank

  def update_left_size(node=nil, adjustment) # size was val
    if @left 
      @left_size += adjustment if node == @left  
    else 
      @left_size = 0
    end
    parent.update_left_size(self, adjustment) if @parent
  end
end

class IndexedBinarySearchTree < BinarySearchTree
  def initialize(root=nil)
    super(root)
    @NodeType = IndexedNode
  end
end
