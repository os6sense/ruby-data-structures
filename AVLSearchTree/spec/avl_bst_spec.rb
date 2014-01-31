require_relative '../avl_bst'
require_relative '../../BinarySearchTree/spec/binary_search_tree_shared'
require_relative '../../IndexedBST/spec/indexed_bst_shared'

describe AVLNode do
#  it_behaves_like 'bst_node'
#  it_behaves_like 'indexed_node'

  def zero_balanced?(new_root)
    new_root.balance.should eq 0
    new_root.left.balance.should eq 0
    new_root.right.balance.should eq 0
  end

  describe :insert do
    let(:root) { AVLNode.new(10) }

    context "when its a left child inserted" do
      it "updates the balance to 1 with one left child" do
        root.should_not_receive(:rebalance)
        root.insert(described_class.new(9))
        root.balance.should eq 1
      end

      it "triggers a rebalance with two left children" do
        root.should_receive(:rebalance).once
        root.insert(described_class.new(9))
        root.insert(described_class.new(8))
      end

      it "works as expected for a more complex example" do
        root = AVLNode.new(10) 
        root = root.insert(described_class.new(9))
        root = root.insert(described_class.new(8))

        # should have been rebalanced
        root.key.should eq 9
        root.parent.should eq nil
        root.right.key.should eq 10
        root.left.key.should eq 8

        root = root.insert(described_class.new(7))
        root.find(described_class.new(8)).should_not eq nil
        root.left.key.should eq 8
        root.left.left.key.should eq 7

        root.parent.should eq nil
        root.key.should eq 9

        root = root.insert(described_class.new(3))

        root.find(described_class.new(3)).should_not eq nil
        root.find(described_class.new(3)).parent.key.should eq 7
        root.find(described_class.new(7)).parent.key.should eq 9
        root.find(described_class.new(8)).parent.key.should eq 7
        # should have rebalanced
        #
        root.key.should eq 9
        root.parent.should eq nil


        # I think this is all working, just my idea of how the tree should
        # look after a rebalance is off
        root = root.insert(described_class.new(4))
        root.parent.should eq nil
        root.key.should eq 7
        root = root.insert(described_class.new(5))
        root.key.should eq 4
        root.left_size.should eq 1
#        root.parent.should eq nil
        # should rebalance
#         [9, 8, 7, 3, 4, 5, 6]
        root = root.insert(described_class.new(6))
      end


      context "updates the left_size property correctly" do
        #    10
        #    /
        #   9
        #  / 
        # 8
        it "updates correctly for 3 left" do
          root = AVLNode.new(10) 
          root = root.insert(described_class.new(9))
          root = root.insert(described_class.new(8))

          root.left_size.should eq 1
          root.left.left_size.should eq 0
          root.right.left_size.should eq 0
        end

        #    10
        #    /
        #   8
        #    \ 
        #     9 
        it "updates correctly for 2 left, one right (elbowed)" do
          root = AVLNode.new(10) 
          root = root.insert(described_class.new(8))
          root = root.insert(described_class.new(9))

          root.left_size.should eq 1
          root.left.left_size.should eq 0
          root.right.left_size.should eq 0
        end

        # 10
        #  \
        #   11
        #    \
        #     12
        it "updates correctly for 3 right" do
          root = AVLNode.new(10) 
          root = root.insert(described_class.new(11))
          root = root.insert(described_class.new(12))

          root.left.left_size.should eq 0
          root.right.left_size.should eq 0
          root.left_size.should eq 1
        end

        # 10
        #  \
        #   12
        #  /  
        # 11
        it "updates correctly for 2 right, one left (elbowed)" do
          root = AVLNode.new(10) 
          root = root.insert(described_class.new(12))
          root = root.insert(described_class.new(11))

          root.left.left_size.should eq 0
          root.right.left_size.should eq 0
          root.left_size.should eq 1
        end
      end

      it "does not trigger a rebalance with one right and two left" do
        root.should_not_receive(:rebalance)
        node = described_class.new(11)

        node.should_not_receive(:rebalance)
        root.insert(node)
        root.insert(described_class.new(9))
        root.insert(described_class.new(8))
      end

      it "updates the balance to 1 with one right and two left" do 
        node = described_class.new(11)
        root.insert(node)
        root.balance.should eq -1
        root.insert(described_class.new(9))
        root.balance.should eq 0
        root.insert(described_class.new(8))
        root.balance.should eq 1
      end

      it "triggers a rebalence on the root node with three left" do
        root.should_receive(:rebalance).once
        root.insert(described_class.new(9))
        root.insert(described_class.new(8))
      end

      it "triggers a single rebalence on the root node with one right and three left" do
        root.should_receive(:rebalance).once
        root.insert(described_class.new(11))
        root.balance.should eq -1 
        root.insert(described_class.new(8))
        root.balance.should eq 0 
        root.insert(described_class.new(9))
        root.balance.should eq 1
        root.insert(described_class.new(7))
        root.balance.should eq 1
        root.insert(described_class.new(6))
      end
    end

    it "updates the balance to zero with one left and one right child" do
      root.should_not_receive(:rebalance)
      root.insert(described_class.new(11))
      root.insert(described_class.new(9))
      root.balance.should eq 0
    end

    context "when its a right child inerted" do
      it "updates the balance to 1 with one right child" do
        root.insert(described_class.new(11))
        root.balance.should eq -1
      end
      it "triggers a rebalance with two right children" do
        root.should_receive(:rebalance).once
        root.insert(described_class.new(11))
        root.insert(described_class.new(12))
      end
      it "updates the balance to 1 with one left and two right" do 
        root.should_receive(:rebalance).once
        root.insert(described_class.new(9))
        root.insert(described_class.new(12))
        root.insert(described_class.new(11))
        root.insert(described_class.new(13))
        root.insert(described_class.new(14))
      end
    end
  end

  describe :rotate_left do

    it "performs the correct rotation on a unbalanced right tree" do
      # Try this with a let and it breaks :/
      root = AVLNode.new(10)
      eleven = described_class.new(11)
      root = root.insert(eleven)

      twelve = described_class.new(12)
      root = root.insert(twelve)

      eleven.left.key.should eq 10
      eleven.left.parent.should eq eleven

      eleven.right.key.should eq 12
      eleven.right.parent.should eq eleven

      root.key.should eq 11

      zero_balanced? root
    end

    it "performs the correct rotation on a unbalanced left tree" do
      # Try this with a let and it breaks :/
      root = AVLNode.new(10)
      nine = described_class.new(9)
      root = root.insert(nine)

      eight = described_class.new(8)
      root = root.insert(eight)

      nine.left.key.should eq 8
      nine.right.key.should eq 10

      root.key.should eq 9
      zero_balanced? root
    end
  end

  describe :rebalance do

    it "Performs the correct rotation on an unbalanced left-right-left tree" do
      # Try this with a let and it breaks :/
      root = AVLNode.new(10)

      twelve = described_class.new(12)
      root = root.insert(twelve)
      root.key.should eq 10

      eleven = described_class.new(11)
      root = root.insert(eleven)

      eleven.key.should eq 11
      eleven.left.key.should eq 10
      eleven.right.key.should eq 12

      root.key.should eq 11
      zero_balanced? root
    end

    it "Performs the correct rotation on an unbalanced right-left-right tree" do
      # Try this with a let and it breaks :/
      root = AVLNode.new(10)

      eight = described_class.new(8)
      root = root.insert(eight)

      nine = described_class.new(9)
      root = root.insert(nine)

      nine.left.key.should eq 8
      nine.right.key.should eq 10

      root.key.should eq 9
      zero_balanced? root
    end
  end

end

describe AVLBinarySearchTree do
  #it_behaves_like 'binary_search_tree'
end

