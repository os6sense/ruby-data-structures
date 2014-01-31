
require_relative '../binary_search_tree'

shared_examples "bst_node" do

  # create short cuts for example nodes
  let(:zero) { described_class.new(0) }
  let(:one) { described_class.new(1) }
  let(:two) { described_class.new(2) }
  let(:three) { described_class.new(3) }
  let(:four) { described_class.new(4) }
  let(:five) { described_class.new(5) }
  let(:six) { described_class.new(6) }
  let(:seven) { described_class.new(7) }
  let(:eight) { described_class.new(8) }
  let(:nine) { described_class.new(9) }
  let(:ten) { described_class.new(10) }

  let(:root) { described_class.new(10) }

  describe :initialize do
    it "takes an integer as a key" do
      described_class.new(1).should be_instance_of(described_class)
    end

    it "takes a character as a key" do
      described_class.new('a').should be_instance_of(described_class)
    end

    it "takes a string as a key" do
      described_class.new("a string").should be_instance_of(described_class)
    end

    it "takes a symbol as a key" do
      described_class.new(:fred).should be_instance_of(described_class)
    end

    it "takes an arbitrary object as a key" do
      described_class.new(Object.new).should be_instance_of(described_class)
    end

    it "takes a value as an optional second parameter" do
      described_class.new(1).should be_instance_of(described_class)
      described_class.new(1, Object.new).should be_instance_of(described_class)
    end
  end

  describe :value do
    let(:value) { "some value" }
    let(:node) { described_class.new(1, value) }

    it "returns the value set in initialize" do
      node.value.should eq "some value"
    end

    it "can be reassigned a value" do
      node.value.should be value
      node.value = "something else"
      node.value.should eq "something else"
    end
  end

  describe :left do
    before(:each) do 
      @root = described_class.new(5)
      @root.left.should eq nil # sanity check
    end

    it "returns the left #{described_class} child node" do
      @root = @root.insert(one)
      @root.left.should eq one
    end

    it "can be directly assigned" do
      @root.left = two
      @root.left.should eq two
    end
  end

  describe :right do
    before(:each) do 
      @root = described_class.new(5)
      @root.left.should eq nil # sanity check
    end

    it "returns the right #{described_class} child node" do
      @root = @root.insert(ten)
      @root.right.should eq ten
    end

    it "can be directly assigned" do
      @root.right = ten
      @root.right.should eq ten
    end
  end

  describe :degree do
    context "with no children" do
      it "returns 0" do
        root.degree.should eq 0
      end
    end

    context "with one child" do
      it "returns 1" do
        node = described_class.new(10)
        node = node.insert(described_class.new(9))
        node.degree.should eq 1
      end
    end

    context "with two children" do
      it "returns 2" do
        node = described_class.new(10)
        node = node.insert(described_class.new(9))
        node = node.insert(described_class.new(11))
        node.degree.should eq 2
      end
    end
  end

  describe :insert do

    context "when the #{described_class} is empty" do
      context "and when the key is less than the value of the #{described_class}" do

        it "the node is assigned to the left branch" do
          node = described_class.new(10)
          node = node.insert(left = described_class.new(1))
          node.left.should eq left
        end
      end
      context "and when the key is greater than the value of the #{described_class}" do
        it "the node is assigned to the right branch" do
          node = described_class.new(10)
          node = node.insert(right = described_class.new(100))
          node.right.should eq right
        end
      end
    end

    describe "when the value is a duplicate" do
      it "should not insert it" do
        node = described_class.new(10)
        node = node.insert(described_class.new(100, "first"))
        node.right.value.should eq "first"

        node = node.insert(described_class.new(100, "second"))
        node.right.value.should eq "first"

        node = node.insert(described_class.new(100, "third"))
        node.right.value.should eq "first"
      end

      it "should handle duplicates without error" do
        node = described_class.new(100, "first")
        node = node.insert(described_class.new(100, "first"))
        expect { node.insert(described_class.new(100)) }.to_not raise_error
      end
    end
  end

  describe :parent do
    it "is nil for a new #{described_class}" do
      node = described_class.new(10)
      node.parent.should eq nil
    end

    it "returns the parent #{described_class}" do
      node = described_class.new(10)
      node = node.insert(described_class.new(100))
      node.right.parent.should eq root
    end
  end

  describe :find do
    let(:n) { described_class.new(21) }

    before(:each) do
      @node = described_class.new(10)
      [1, 2, 3, 4, 5, 21, 1213, 3, 13, 4412].each do | x |
        @node = @node.insert(described_class.new(x))
      end
    end

    it "returns nil if the #{described_class} is not present" do
      @node.find(described_class.new(123)).should eq nil
    end

    it "it returns the #{described_class} if the #{described_class} is present" do
      found = @node.find(n) 
      found.should eq n
    end
  end

  describe :delete do

    # Create a simple tree of the form
    #                 6
    #                / \
    #               4   8
    #              /     \
    #             2      10 
    #              \     /
    #               1   9
    before(:each) do
      @simple_tree = six # described_class.new(6) 
      @simple_tree = @simple_tree.insert(four.clone) 
      @simple_tree = @simple_tree.insert(two.clone) 
      @simple_tree = @simple_tree.insert(one.clone) 
      @simple_tree = @simple_tree.insert(eight.clone) 
      @simple_tree = @simple_tree.insert(ten.clone) 
      @simple_tree = @simple_tree.insert(nine.clone) 
    end

    context "when it is a leaf with no children (degree 0)" do
      it "the node is set to nil" do
        @simple_tree.find(one).degree.should eq 0
        @simple_tree = @simple_tree.delete(one)
        @simple_tree.find(one).should eq nil
      end
    end

    context "when it is a node with a single branch (degree 1)" do
      context "when it is replaced by its child (child on right)" do
        before(:each) { @simple_tree = @simple_tree.delete(two) }

        it "is deleted" do
          @simple_tree.find(two).should eq nil 
        end

        it "assigns to the correct side" do
          parent = @simple_tree.find(four)
          parent.left.should eq one
          parent.right.should eq nil
        end

        it "does not lose the former child" do
          @simple_tree.find(one).should_not eq nil 
        end

        it "sets the former childs parent to the new parent" do
          @simple_tree.find(one).parent.should eq four
        end

        it "leaves the child node unaffected" do
          @simple_tree.find(one).left.should eq nil
          @simple_tree.find(one).right.should eq nil
        end
      end

      context "when it is replaced by its child (child on left)" do
        before(:each) { @simple_tree = @simple_tree.delete(ten) }

        it "is deleted" do
          @simple_tree.find(ten).should eq nil 
        end

        it "assigns to the correct side" do
          parent = @simple_tree.find(eight)
          parent.left.should eq nil
          parent.right.should eq nine
        end

        it "does not lose the former child" do
          @simple_tree.find(nine).should_not eq nil 
        end

        it "sets the former childs parent to the new parent" do
          @simple_tree.find(nine).parent.should eq eight
        end

        it "leaves the child node unaffected" do
          @simple_tree.find(nine).left.should eq nil
          @simple_tree.find(nine).right.should eq nil
        end
      end
    end

    context "when it is a node with two branches (degree 2)" do
      before(:each) do
        # Create a node with degree = 2. 
        # Note that If we dont clone, our prepared
        # values will be altered since it seems let cant make a constant :/
        @simple_tree = described_class.new(6)
        @simple_tree = @simple_tree.insert( four.clone )
        @simple_tree = @simple_tree.insert( eight.clone )
        @simple_tree = @simple_tree.insert( nine.clone )
        @simple_tree = @simple_tree.insert( seven.clone )

        # Sanity checking
        @simple_tree.find(eight).degree.should eq 2
        @simple_tree.find(nine).parent.should eq eight
        @simple_tree.find(seven).parent.should eq eight
      end

      it "sets the key of the deleted node equal to the left, largest value" do
        node = @simple_tree.find(eight)
        largest = node.left.largest

        @simple_tree.delete(eight)

        # node isnt really deleted - its key is swapped
        node.should eq largest
      end

      it "can find the root node" do
        node = @simple_tree.find(six)
        node.should_not be nil
        node.should eq six
      end

      it "should leave the node.right value unaltered" do
        node = @simple_tree.find(eight)
        right = node.right

        @simple_tree.delete(node)

        # node isnt really deleted - its key is swapped
        node.right.should eq right
      end

      it "should not lose the child nodes" do
        @simple_tree = @simple_tree.delete(eight)
        @simple_tree.find(nine).should_not eq nil
        @simple_tree.find(seven).should_not eq nil
      end

      it "sets the parent of the previous child nodes to the new parent" do
        @simple_tree = @simple_tree.delete(eight)

        @simple_tree.find(nine).parent.key.should eq 7
        @simple_tree.find(seven).parent.key.should eq 6
      end

      it "can hande the node not being present" do
      end


      it "deletes the node" do
        @simple_tree = @simple_tree.delete(eight)
        @simple_tree.find(eight).should eq nil
      end

      it "can delete the root node" do
        @simple_tree = @simple_tree.delete(six)
        @simple_tree.find(six).should eq nil
      end
    end
  end
end

shared_examples "binary_search_tree" do
  let(:tree) { described_class.new() }
  let(:simple_tree) { described_class.new() }

  before(:each) do
    # Yes, 2 trees. I find it easier to check my logic with the 
    # numerical tree and the character tree is a "known" correct
    # traversale.
    %w{F B G A D I C E H}.each { | x | tree.insert(x) }
    %w{2 1 3 4 0}.each { | x | simple_tree.insert(x) }
  end

  # belongs in second example group
  #it "returns nil if the node doesnt exist" do
    #simple_tree.find(described_class.new(22)).should eq nil
    #simple_tree.delete(described_class.new(22)).should eq nil
  #end
  describe :find do
    it "returns nil if a node is not present" do
      tree.find('Z').should eq nil
    end

    it "it returns the node if a node is present" do
      found = tree.find('A') 
      found.key.should eq 'A'
    end
  end

  describe :traverse do
    it "does an in_order traversal by default" do
        tree.traverse.should eq tree.traverse(:in_order)
    end

    context "with in_order traversal" do
      it "it performs a traversal returning the correct (in_order) array" do
        tree.traverse.should eq %w{A B C D E F G H I}
        simple_tree.traverse.should eq %w{0 1 2 3 4}
      end
    end
    context "with pre_order traversal" do
      it "it performs a traversal returning the correct (pre_order) array" do
        tree.traverse(:pre_order).should eq %w{F B A D C E G I H}
        simple_tree.traverse(:pre_order).should eq %w{2 1 0 3 4 }
      end
    end
    context "with post_order traversal" do
      it "it performs a traversal returning the correct (post_order) array" do
        simple_tree.traverse(:post_order).should eq %w{0 1 4 3 2}
        tree.traverse(:post_order).should eq %w{A C E D B H I G F}
      end
    end
  end

end
