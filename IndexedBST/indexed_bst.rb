require_relative '../BinarySearchTree/binary_search_tree'

# Adds an index to a binary tree via means of the left_size property.
class IndexedNode  < Node
  attr_accessor :left_size
  def initialize(key)
    super(key)
    @left_size = 0
  end

  # left_size is calculated on insert and causes all parent nodes
  # to recalculate their left_size.
  def insert(node)
    # recalculate from the inserted nodes parent up
    unless (tmp_node, tmp_parent = super(node)).nil?
      tmp_parent._recalc_left_size(tmp_node, 1) 
    end
  end

  # Need to recalculate left_size on deletion
  def delete
    # TODO: Does this work for all node types?
    parent._recalc_left_size(self, -1) if parent
    super
  end

  # Given an index, return the node at that index. Aliased by []
  def rank(idx_rank)
#    puts "****#{idx_rank} #{left_size}, #{self.key}"
    return self if idx_rank == left_size
    return left.rank(idx_rank) if idx_rank < left_size
    return right.rank(idx_rank - left_size - 1) 
  end
  alias [] rank

protected
  def _traverse &block
    left._traverse(&block) if @left
    yield self
    right._traverse(&block) if @right 
  end

  # calc left size is the TOTAL value of the number of nodes (both left and
  # right) to the left of the current node. 
  def _recalc_left_size(node, val)
    @left_size += val if node == left
    parent._recalc_left_size(self, val) if parent
  end
end

class IndexedBinarySearchTree < BinarySearchTree
  def initialize(root=nil)
    super(root)
    @NodeType = IndexedNode
  end
end
