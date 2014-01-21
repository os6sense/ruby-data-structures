
class Node 
  include Comparable

  attr_accessor :key, 
                :left, 
                :right, 
                :parent

  def initialize(key)
    @key = key 
  end

  def <=>(other)
    key <=> other.key
  end

  # Returns: 
  def insert(node)
    if node < self
      return left.insert(node) if left
      @left, @left.parent = node, self
    elsif node > self
      return right.insert(node) if right
      @right, @right.parent = node, self
    end
  end

  # Returns::
  def find(node)
    return left.find(node) if node < self && left
    return right.find(node) if node > self && right
    self if node == self
  end

  def delete
    self > parent ? 
      parent.right = nil : parent.left = nil if degree == 0 

    if degree == 1
      (left || right).parent = parent
      self > parent ? 
        parent.right = left || right : parent.left = left || right 
    end

    # Neccessary to avoid RGC leak since I still hold a reference parent?
    @parent = nil if degree == 1 or degree == 0
    
    left.largest.tap { | n | @key = n.key; n.delete } if degree == 2
  end

  def is_leaf? 
    left.nil? && right.nil?
  end

  def degree
    (left ? 1 : 0) + (right ? 1 : 0)
  end

  def smallest
    left ? left.smallest : self
  end

  def largest
    right ? right.largest : self
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
    node = @root.find(@NodeType.new(key))
    node.delete unless node.nil?
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


