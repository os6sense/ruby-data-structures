
shared_examples "indexed_node" do

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
  let(:eleven) { described_class.new(11) }
  let(:twelve) { described_class.new(12) }

  describe :left_size do
    it "should equal zero with no left nodes" do
      root = described_class.new(10) 
      root.left_size.should eq 0
    end

    context "when items are inserted" do

      before(:each) { @root = described_class.new(10) }

      # ONE LEFT i.e.    10
      #                 /
      #                9
      context "with one left item" do
        before(:each) { @root = @root.insert(nine) }

        it "is correct for insert" do
          nine.left_size.should eq 0
          @root.left_size.should eq 1
        end

        context "when a node is deleted" do
          it "is correct if the root node is deleted" do
            @root = @root.delete(ten)
            @root.left_size.should eq 0
          end
          it "is correct if the left node is deleted" do
            @root = @root.delete(nine)
            @root.left_size.should eq 0
          end
        end
      end

      # ONE RIGHT i.e.  10
      #                   \
      #                    11
      context "with one right item" do
        before(:each) { @root = @root.insert(eleven) }

        it "is correct for insert" do
          eleven.left_size.should eq 0
          @root.left_size.should eq 0
        end

        context "when a node is deleted" do
          it "is correct when the root node is deleted" do
            @root = @root.delete(ten)
            @root.left_size.should eq 0
          end
          it "is correct if the right node is deleted" do
            @root = @root.delete(eleven)
            @root.left_size.should eq 0
          end
        end
      end

      # TWO LEFT i.e.    10
      #                 /
      #                9
      #               /
      #              8
      context "with two left items" do
        before(:each) do
          @root = @root.insert(nine)
          @root = @root.insert(eight)
        end
        
        it "is correct for insert" do
          @root.left_size.should eq 2
          nine.left_size.should eq 1
          eight.left_size.should eq 0
        end

        context "when a node is deleted" do
          it "is correct when the root node is deleted" do
            @root = @root.delete(ten)
            @root.left_size.should eq 1
            @root.find(eight).left_size.should eq 0
          end

          it "is correct when the middle node is deleted" do
            @root = @root.delete(nine)
            @root.left_size.should eq 1
            @root.find(eight).left_size.should eq 0
          end

          it "is correct when the bottom node is deleted" do
            @root = @root.delete(eight)
            @root.left_size.should eq 1
            @root.find(nine).left_size.should eq 0
          end
        end
      end

      # ONE LEFT i.e.    10
      # ONE RIGHT       /
      # (ELBOWED)      8
      #                 \
      #                  9
      context "with two left (elbowed) items" do
        before(:each) do
          @root = @root.insert(eight)
          @root = @root.insert(nine)
        end
        
        it "is correct for insert" do
          @root.left_size.should eq 2
          nine.left_size.should eq 0
          eight.left_size.should eq 0
        end

        context "when a node is deleted" do
          it "is correct when the root node is deleted" do
            @root = @root.delete(ten)
            @root.should eq nine

            @root.right.should eq nil
            @root.left.should eq eight

            @root.find(eight).left_size.should eq 0
            @root.left_size.should eq 1
          end

          it "is correct when the middle node is deleted" do
            @root = @root.delete(eight)
            @root.left_size.should eq 1
            @root.find(nine).left_size.should eq 0
          end

          it "is correct when the bottom node is deleted" do
            @root = @root.delete(nine)
            @root.left_size.should eq 1
            @root.find(eight).left_size.should eq 0
          end
        end
      end

      # TWO RIGHT i.e.    10
      #                     \
      #                     11
      #                       \
      #                       12
      context "with two right items inserted it is correct" do
        before(:each) do
          @root = @root.insert(eleven)
          @root = @root.insert(twelve)
          #@root.should eq ten
        end

        it "is correct for insert" do
          @root.left_size.should eq 0
          eleven.left_size.should eq 0
          twelve.left_size.should eq 0
        end
        context "when a node is deleted" do
          it "is correct when the root node is deleted" do
            @root = @root.delete(ten)
            @root.left_size.should eq 0
            twelve.left_size.should eq 0
          end
          it "is correct when the middle node is deleted" do
            @root = @root.delete(eleven)
            @root.left_size.should eq 0
            @root.find(twelve).left_size.should eq 0
          end
          it "is correct when the bottom node is deleted" do
            @root = @root.delete(twelve)
            @root.left_size.should eq 0
            @root.find(eleven).left_size.should eq 0
          end
        end

      end

      # ONE RIGHT i.e.    10
      # ONE LEFT            \
      # (ELBOWED)           12
      #                     /
      #                   11
      context "with two right items (elbowed) inserted" do
        before(:each) do
          @root = @root.insert(twelve)
          @root = @root.insert(eleven)
          #@root.should eq ten
        end

        it "is correct for insert" do
          @root.left_size.should eq 0
          twelve.left_size.should eq 1
          eleven.left_size.should eq 0
        end

        context "when a node is deleted" do
          it "is correct when the root node is deleted" do
            @root = @root.delete(ten)
            @root.should eq eleven
            @root.right.should eq twelve

            @root.left.should eq nil
            eleven.left_size.should eq 0
            @root.left_size.should eq 0
          end
          it "is correct when the middle node is deleted" do
            @root = @root.delete(twelve)
            @root.left_size.should eq 0
            @root.find(eleven).left_size.should eq 0
          end
          it "is correct when the bottom node is deleted" do
            @root = @root.delete(eleven)
            @root.left_size.should eq 0
            @root.find(twelve).left_size.should eq 0
          end
        end
      end
      
      it "returns the number of items in the left subtree" do
        [9, 8, 7, 3, 4, 5, 6].each do | x |
          @root = @root.insert(described_class.new(x))
        end
        @root.left_size.should eq 7
      end

      it "doesnt count items in the right subtree (doh!)" do
        @root = @root.insert(described_class.new(11))
        @root = @root.insert(described_class.new(13))
        @root.left_size.should eq 0
      end
    end
  end

  describe :[] do
    it "returns the member at the nth position" do
      root = described_class.new(10) 
      [9, 8, 7, 3, 4, 5, 6].each do | x |
        root = root.insert(described_class.new(x))
      end
      root[0].key.should eq 3
      root[7].key.should eq 10
    end
  end

  describe :rank do
    let(:in_order) { [3, 4, 5, 6, 7, 8, 9, 10] }

    before(:each) do
      @root = described_class.new(10) 
      [9, 8, 7, 3, 4, 5, 6].each do | x |
        @root = @root.insert(described_class.new(x))
      end
    end
     
    it "returns the node at position n" do
      in_order.each_with_index { |i, idx| @root.rank(idx).key.should eq i }
    end

    context "after an insert" do  
      it "is updated correctly" do
        @root = @root.insert(described_class.new(12))
        @root.rank(8).key.should eq 12

        @root = @root.insert(described_class.new(1))
        @root.rank(0).key.should eq 1
        @root.rank(8).key.should eq 10
        @root.rank(9).key.should eq 12

        @root = @root.insert(described_class.new(15))
      #  @root.rank(10).key.should eq 15

        @root = @root.insert(described_class.new(15))
        @root.rank(10).key.should eq 15

        @root = @root.insert(described_class.new(16))
        @root.rank(11).key.should eq 16

        @root = @root.insert(described_class.new(-1))
        @root.rank(0).key.should eq -1
        @root.rank(12).key.should eq 16
      end
    end

    context "after a delete" do
      it "is updated correctly for a degree 0 node" do
        @root = described_class.new(10) 
        [9, 8, 7, 6, 5].each do | x |
          @root = @root.insert(described_class.new(x))
        end

        node = @root.find(described_class.new(5))
        node.degree.should eq 0 
        @root.rank(0).key.should eq 5
        @root.rank(1).key.should eq 6
        @root.rank(2).key.should eq 7

        @root = @root.delete(node)
        @root.key.should eq 10
        @root.left.key.should eq 9

        @root.rank(1).key.should eq 7
        @root.rank(0).key.should eq 6
      end

      it "is updated correctly for a degree 1 node" do
        node = @root.find(described_class.new(3))
        node.degree.should eq 1 # sanity check
        @root = @root.delete(node)

        @root.rank(0).key.should eq 4
        @root.rank(2).key.should eq 6
        @root.rank(6).key.should eq 10
      end

      it "is updated correctly for a degree 2 node" do
        @root = @root.insert(described_class.new(12))
        @root = @root.insert(described_class.new(11))
        @root = @root.insert(described_class.new(13))

        node = @root.find(described_class.new(12))

        @root = @root.delete(node)

        in_order.each_with_index { |i, idx| @root.rank(idx).key.should eq i }
        @root.rank(7).key.should eq 10
        @root.rank(8).key.should eq 11
        @root.rank(9).key.should eq 13
      end
    end
  end
end
