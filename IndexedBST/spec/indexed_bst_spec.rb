require_relative '../indexed_bst'
require_relative '../../BinarySearchTree/spec/binary_search_tree_shared'

require_relative 'indexed_bst_shared'

describe IndexedNode do
  it_behaves_like 'bst_node'
  it_behaves_like 'indexed_node'
end

describe IndexedBinarySearchTree do
  it_behaves_like 'binary_search_tree'
end

