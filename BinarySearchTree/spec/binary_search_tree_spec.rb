require_relative 'binary_search_tree_shared'

describe Node do
  it_behaves_like "bst_node"
end

describe BinarySearchTree do
  it_behaves_like "binary_search_tree"
end

