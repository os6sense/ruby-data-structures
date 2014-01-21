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
    _calc_left_size if super(node) 
  end

  # Need to recalculate left_size on deletion
  def delete
    # TODO: Does this work for all node types?
    tmp_parent = @parent
    super
    tmp_parent._calc_left_size if tmp_parent
  end

  # Given an index, return the node at that index. Aliased by []
  # I STILL dont understand this fully.
  def rank(idx_rank)
    puts "****#{idx_rank} #{left_size}, #{self.key}"
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
  def _calc_left_size
    # TODO: ineffficient I can do better
    @left_size = 0
    left._traverse { @left_size +=1  } if left
    parent._calc_left_size if parent
  end
end

class IndexedBinarySearchTree < BinarySearchTree
  def initialize(root=nil)
    super(root)
    @NodeType = IndexedNode
  end
end
