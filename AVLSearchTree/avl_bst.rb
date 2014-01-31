require_relative '../IndexedBST/indexed_bst'

# Adds an index to a binary tree via means of the left_size property.
class AVLNode < IndexedNode
  attr_accessor :balance
  def initialize(key, value=nil)
    super(key, value)
    @balance = 0
  end

  # Description::
  # Insert a new node. It is important to note that a rebalance
  # will change the shape of the tree, moving nodes about and
  # hence any references to a node may be changed. In order to
  # ensure youre pointing at the root of a tree after an insert
  # always call insert as :
  #   root = root.insert(node)
  def insert(node, root=nil, &block)
    root = self if root.nil?
    
    root = super(node, root) do | i_node | 
      new_root = i_node.parent.update_balance(i_node, 1) if i_node
      block.call(i_node) if block

      if new_root && new_root.parent.nil?
        return new_root
      end
    end

    return root
  end

  def delete(node=nil, root=nil, &block)
    super(node, root) do | dn |
      dn.update_balance(nil, -1) if dn
      block.call(dn) if block
    end
  end

  # Description::
  # After an insert we want to determine if the insert has made any parent
  # nodes out of balance.
  def update_balance(node,  op)
    node == right ? @balance -= op : @balance += op
    return rebalance if @balance < -1 or @balance > 1
    return parent.update_balance(self,  op) if parent && @balance != 0
  end

  def rebalance
    if balance < 0
      @right.rotate_right if @right.balance > 0
      return rotate_left
    elsif balance > 0
      @left.rotate_left if @left.balance < 0 
      return rotate_right
    end
  end

  # update the parent so that the correct left/right points to self
  def update_parent(side)
    if @parent.left == self
      @parent.left = side
    else
      @parent.right = side
    end
  end

  def rotate_left
#   puts "Rotate Left"
    # promote the right child to the root of the new subtree
    @right.parent = @parent 
    update_parent(@right) if @parent
    @parent = @right

    # move old root to the left child of the new root
    if @parent.left 
      @right = parent.left
    else
      @right = nil
    end

    @parent.left = self

#   puts "parent [#{parent.key}]: #{@parent.left_size} , left_size [#{key}] #{@left_size}"
    @parent.left_size, @left_size = @left_size + 1, @parent.left_size
#   puts "parent [#{parent.key}]: #{@parent.left_size} , left_size [#{key}] #{@left_size}"
#   puts "====================================="

    @balance = balance + 1 - [@parent.balance, 0].min
    @parent.balance = @parent.balance + 1 + [balance, 0].max

    return @parent
  end

  def rotate_right
#   puts "Rotate Right"
    @left.parent = @parent
    update_parent(@left) if @parent
    @parent = @left

    # move old root to the left child of the new root
    if @parent.right 
      @left = @parent.right
    else
      @left = nil
    end

    @parent.right = self

#   puts "parent [#{parent.key}]: #{@parent.left_size} , left_size [#{key}] #{@left_size}"
    @parent.left_size, @left_size = @left_size -1, 0 # @parent.left_size
#   puts "parent [#{parent.key}]: #{@parent.left_size} , left_size [#{key}] #{@left_size}"
#   puts "====================================="

    @balance = balance - 1 - [@parent.balance, 0].max
    @parent.balance = @parent.balance - 1 - [balance, 0].max

    return @parent
  end
end

class AVLBinarySearchTree < IndexedBinarySearchTree
  def initialize(root=nil)
    super(root)
    @NodeType = AVLNode
  end
end
