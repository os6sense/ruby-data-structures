
class Node 
  include Comparable

  attr_accessor :key,
                :value,
                :left, 
                :right, 
                :parent

  # Description::
  #
  # Initialize a new node.
  #
  # Params::
  # +key+ - the key value for the node.
  # +value+ - an optional value to store. See +#value+
  def initialize(key, value=nil)
    @key = key 
    @value = value
  end

  # Description::
  # Compare this node to another node. 
  #
  # Returns::
  # -1 if less, 0 if equal, 1 if greater
  def <=>(other)
    key <=> other.key
  end

  # Description::
  # Search through child nodes to find another node.
  #
  # Params::
  # +node+ - The node to find.
  #
  # Returns::
  # The node if it was found, nil otherwise
  def find(node)
    return left.find(node) if node < self && left
    return right.find(node) if node > self && right
    self if node == self
  end

  # Description::
  # Insert a node as a child of an existing node.
  # 
  # Returns:: 
  # self  Note: This is to support insert operations in subclasses which
  # may alter the root node. Use the value yielded if you need 
  # access to the inserted value.
  #
  # Yields::
  # The inserted block if an insert operation was performed, otherwise
  # yields nil (this means that the node is a duplicate)
  #
  # Example usage and notes:
  # root = Node.new('A')
  # root = root.insert('B')
  #
  # note that we could just write +node.insert('B') without assinging the 
  # return value to +node+ however if the node is swapped out for a node
  # which self balances (and hence is able to change the root of the tree
  # on insert) then root will no longer point to the actual root of the 
  # tree.
  def insert(node, root=nil, &block)
    root = self if root.nil? # preserve the root of the insert 
                             # so that we can support AVL rebalances 
                             # and NOT break the BST implementation
    if node < self
      return left.insert(node, root) if left
      @left, @left.parent = node, self 
      yield @left if block 
    elsif node > self
      return right.insert(node, root) if right
      @right, @right.parent = node, self
      yield @right if block
    else
      yield nil if block
    end

    return root
  end

  # Description::
  # Deletes a node.
  #
  # Due to the fact that classes which inherit from bst_node may
  # perform reorder operations there are TWO ways to use delete.
  # + root = root.delete(node_to_delete) + will return the root
  # and hence is the *prefared* way to use delete. However it
  # is still possible to call + node.delete + - just be aware
  # that if any reordering operations take place that the value
  # of + node + may not be what you expect.
  def delete(node=nil, root=nil, &block)
    root = self if root.nil? # preserve the root of the insert 
                             # so that we can support AVL rebalances 
                             # and NOT break the BST implementation

    # provides a cleaner interface for deletion.
    return find_and_delete_child(node, root, &block) if node != nil

    case degree
    when 0
      return nil if parent.nil?

      self == parent.right ?
        parent.right = nil : parent.left = nil 
        # Note: Calls INHERITED classes delete method, if we have
        # inherited, hence if we pass &block, that block is executed TWICE!
        # Obvious but it took me a while to work out what was going on.
      yield parent if block 
    when 1
      return find_and_replace(self, root) if parent.nil?

      (left || right).parent = parent
      self == parent.right ?
        parent.right = (left || right) : parent.left = (left || right)
      yield (left||right) if block
    when 2
      return find_and_replace(self, root) 
    end

    return root
  end


  # Description::
  # has this node any children?
  #
  # Returns::
  # true if left or right nodes exist, false otherwise.
  def is_leaf? 
    left.nil? && right.nil?
  end

  # Description::
  # returns the degree (number of direct child nodes populated)
  #
  # Returns::
  # 0 if empty, 1 if the left or right nodes exist, 2 for both.
  def degree
    (left ? 1 : 0) + (right ? 1 : 0)
  end

  # Description::
  # Finds the smallest child node.
  #
  # Returns::
  # returns the smallest child node (or self if no smaller child nodes)
  def smallest
    left ? left.smallest : self
  end

  # Description::
  # Finds the largest child node.
  #
  # Returns::
  # returns the largest child node (or self if no larger child nodes)
  def largest
    right ? right.largest : self
  end

private
  # Extracted from delete to clean up the method. Finds a node
  # and then calls delete on it.
  def find_and_delete_child(node, root, &block)
    find(node).tap { | fn |
      return fn.delete(nil, root) { yield if block } 
    }
    yield nil
    return root
  end

  # Extracted from delete to clean up the method. Find a suitable
  # candidate to replace a node with, set the key of the passed node,
  # then delete the replacement candidate.
  def find_and_replace(node, root, &block)
    (node.left ? 
     node.left.largest : node.right.smallest).tap do | rep | 
      node.key, node.value = rep.key, rep.value
      return rep.delete(nil, root)
    end
  end

end

class BinarySearchTree
  def initialize(root=nil)
    @root = root
    @NodeType = Node
  end

  def insert(key)
    @root = @NodeType.new(key) if @root.nil?
    @root.insert( @NodeType.new(key) )
  end

  def delete(key)
    @root = @root.delete(@NodeType.new(key))
  end

  def find(key)
    return @root.find(@NodeType.new(key)) if @root
  end

  def traverse(order=:in_order)
    [].tap { |out| method(order).call(@root) { |node| out << node.key } }
  end

protected

  def in_order(node, &block)
    return if node.nil?
    in_order(node.left, &block) 
    yield node
    in_order(node.right, &block)
  end

  def pre_order(node, &block) 
    return if node.nil?
    yield node
    pre_order(node.left, &block)
    pre_order(node.right, &block) 
  end

  def post_order(node, &block)
    return if node.nil?
    post_order(node.left, &block) 
    post_order(node.right, &block) 
    yield node
  end
end


