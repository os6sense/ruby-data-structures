
require_relative '../binary_search_tree'

require 'pry-byebug'

shared_examples "bst_node" do
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
  end

  describe :left do
    let(:root) { described_class.new(10) }
    it "returns the left #{described_class}" do
      root.insert(left = described_class.new(1))
      root.left.should eq left
    end

    it "can be assigned to a new value" do
      root.insert(described_class.new(1))
      root.left = described_class.new(1000)
      root.left.key.should eq 1000
    end
  end

  describe :right do
    let(:root) { described_class.new(10) }
    it "returns the right #{described_class}" do
      root.insert(right = described_class.new(100))
      root.right.should eq right
    end

    it "can be assigned to a new value" do
      root.insert(described_class.new(100))
      root.right = described_class.new(1000)
      root.right.key.should eq 1000
    end
  end

  describe :degree do
    let(:root) { described_class.new(10) }
    context "with no children" do
      it "returns 0" do
        root.degree.should eq 0
      end
    end
    context "with one child" do
      it "returns 1" do
        root.insert(described_class.new(9))
        root.degree.should eq 1
      end
    end
    context "with two children" do
      it "returns 2" do
        root.insert(described_class.new(9))
        root.insert(described_class.new(11))
        root.degree.should eq 2
      end
    end
  end

  describe :insert do
    let(:root) { described_class.new(10) }
    context "when the #{described_class} is empty" do
      context "and when the key is less than the value of the #{described_class}" do
        it "becomes the left branch" do
          root.insert(left = described_class.new(1))
          root.left.should eq left
        end
      end
      context "and when the key is greater than the value of the #{described_class}" do
        it "becomes the right branch" do
          root.insert(right = described_class.new(100))
          root.right.should eq right
        end

        it "sets the parent" do
          root.insert(described_class.new(100))
          root.right.parent.should eq root
        end

      end
    end
  end

  describe :parent do
    let(:root) { described_class.new(10) }

    it "is nil for the root #{described_class}" do
      root.parent.should eq nil
    end

    it "returns the parent #{described_class}" do
      root.insert(described_class.new(100))
      root.right.parent.should eq root
    end
  end


  describe :find do
    let(:root) { described_class.new(10) }
    let(:n) { described_class.new(21) }

    before(:each) do
      [1, 2, 3, 4, 5, 21, 1213, 3, 13, 4412].each do | x |
        root.insert(described_class.new(x))
      end
    end

    it "returns nil if the #{described_class} is not present" do
      root.find(described_class.new(123)).should eq nil
    end

    it "it returns the #{described_class} if the #{described_class} is present" do
      found = root.find(n) 
      found.should eq n
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

  describe :delete do
    it "returns nil if the node doesnt exist" do
      simple_tree.delete('22').should eq nil
    end

    context "when it is a leaf with no children" do
      it "the node is set to nil" do
        simple_tree.delete('0')
        simple_tree.find('0').should eq nil
      end
      it "the node is set to nil" do
        simple_tree.delete('5')
        simple_tree.find('5').should eq nil
      end
    end

    context "when it is a node with a single branch" do
      before(:each) do
        # Sanity check, is the tree "correct"
        simple_tree.find('4').parent.key.should eq '3'
        simple_tree.find('4').parent.left.should eq nil
        simple_tree.find('4').parent.right.key.should eq '4'

        simple_tree.find('0').parent.key.should eq '1'
        simple_tree.find('0').parent.right.should eq nil
        simple_tree.find('0').parent.left.key.should eq '0'
      end

      it "is replaced by the branch if greater" do
        simple_tree.delete('3') 

        simple_tree.find('3').should eq nil 
        simple_tree.find('4').should_not eq nil 
        simple_tree.find('4').parent.key.should eq '2'
      end

      it "is replaced by the branch if less than" do
        simple_tree.delete('1') 

        simple_tree.find('1').should eq nil 
        simple_tree.find('0').should_not eq nil 
        simple_tree.find('0').parent.key.should eq '2'
      end
    end

    context "when it is a node with two branches" do
      before(:each) do
        # Create a node with degree = 2
        simple_tree.insert('6')
        simple_tree.insert('5')
        simple_tree.insert('7')

        # Sanity checking
        simple_tree.find('6').degree.should eq 2
        simple_tree.find('5').parent.key.should eq '6'
        simple_tree.find('7').parent.key.should eq '6'
      end

      it "deletes the node" do
        simple_tree.delete('6')
        simple_tree.find('6').should eq nil
      end

      it "sets the key of the deleted node equal to the smallest value" do
        simple_tree.delete('6')

        simple_tree.find('5').should_not eq nil
        simple_tree.find('7').should_not eq nil

        simple_tree.find('5').right.key.should eq '7'
        simple_tree.find('5').left.should eq nil
      end

      it "sets the parent of the previous child nodes to the new parent" do
        simple_tree.delete('6')
        simple_tree.find('4').parent.key.should eq '3'
        simple_tree.find('5').parent.key.should eq '4'
        simple_tree.find('7').parent.key.should eq '5'
      end

      # %w{2 1 3 4 0}.each { | x | simple_tree.insert(x) }
      it "can delete the root node" do
        simple_tree.delete('5')
        simple_tree.find('5').should eq nil

        tree.delete('F')
        tree.find('F').should eq nil
      end
    end

  end
end
