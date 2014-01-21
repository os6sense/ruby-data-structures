require_relative '../indexed_bst'
require_relative '../../BinarySearchTree/spec/binary_search_tree_shared'

#require 'pry-byebug'

describe IndexedNode do
  it_behaves_like 'bst_node'

  describe :left_size do
    let(:root) { described_class.new(10) }

    it "should equal zero with no left nodes" do
      root.left_size.should eq 0
    end

    context "with items in the tree" do
      it "returns the number of items in the left subtree" do
        [9, 8, 7, 3, 4, 5, 6].each do | x |
          root.insert(described_class.new(x))
        end
        root.left_size.should eq 7
      end
      it "doesnt count items in the right subtree (doh!)" do
        root.insert(described_class.new(11))
        root.insert(described_class.new(12))
        root.left_size.should eq 0
      end
    end
  end

  describe :[] do
    let(:root) { described_class.new(10) }

    it "returns the member at the nth position" do
      [9, 8, 7, 3, 4, 5, 6].each do | x |
        root.insert(described_class.new(x))
      end
      root[0].key.should eq 3
      root[7].key.should eq 10
    end
  end

  describe :rank do
    let(:root) { described_class.new(10) }

    before(:each) do
      [9, 8, 7, 3, 4, 5, 6].each do | x |
        root.insert(described_class.new(x))
      end
    end
     
    it "returns the node at position n" do
      root.rank(0).key.should eq 3
      root.rank(2).key.should eq 5
      root.rank(5).key.should eq 8
      root.rank(7).key.should eq 10
    end

    it "is updated after an insert" do  
      root.insert(described_class.new(12))
      root.rank(8).key.should eq 12

      root.insert(described_class.new(1))
      root.rank(0).key.should eq 1
      root.rank(8).key.should eq 10
      root.rank(9).key.should eq 12
      root.insert(described_class.new(15))
      root.rank(10).key.should eq 15
    end

    it "is updated after a delete" do
      # TODO: ensure we check this for degree 0, 1 and 2 nodes
      node = root.find(described_class.new(3))
      node.delete
      root.rank(0).key.should eq 4
      root.rank(6).key.should eq 10

      root.insert(described_class.new(12))
      root.insert(described_class.new(11))
      root.insert(described_class.new(13))

      node = root.find(described_class.new(12))
      node.delete

      root.rank(7).key.should eq 11
      root.rank(8).key.should eq 13
    end
  end
end

describe IndexedBinarySearchTree do
  it_behaves_like 'binary_search_tree'
end

