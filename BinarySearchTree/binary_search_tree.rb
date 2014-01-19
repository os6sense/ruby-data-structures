
class Node 
  include Comparable

  attr_accessor :key, 
                :left, 
                :right, 
                :parent

  def initialize(key)
    @key = key 
    @height = 0
  end

  def <=>(other)
    @key <=> other.key
  end

  # Returns: 
  # nil if node was inserted 
  # the existing node if it already exists 
  def insert(node)
    if node < self
      return @left.insert(node) if @left
      @left, @left.parent = node, self
    elsif node > self
      return @right.insert(node) if @right
      @right, @right.parent = node, self
    else 
      return self
    end
  end

  # Returns::
  def find(node)
    return self if node == self
    return @left.find(node) if @left and node < self
    return @right.find(node) if @right and node > self
  end

  def delete
    self > parent ? 
      parent.right = nil : parent.left = nil if degree == 0 

    if degree == 1
      (left || right).parent = parent
      self > parent ? 
        parent.right = left || right : parent.left = left || right 
    end
    
    left.largest.tap { | n | 
      self.key = n.key; n.delete } if degree == 2
  end

  def is_leaf? 
    @left.nil? && @right.nil?
  end

  def degree
    (@left ? 1 : 0) + (@right ? 1 : 0)
  end

  def smallest
    @left ? @left.smallest : self
  end

  def largest
    @right ? @right.largest : self
  end
end

class BinarySearchTree
  def initialize(root=nil)
    @root = root
  end

  def insert(key)
    @root = Node.new(key) if @root.nil?
    @root.insert(Node.new(key) )
  end

  def delete(key)
    node = @root.find(Node.new(key))
    node.delete unless node.nil?
  end

  def find(key)
    return @root.find(Node.new(key)) if @root
  end

  def traverse(order=:in_order)
    arr = []
    method(order).call(@root) { | n | arr << n.key }
    return arr
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


