require 'test_helper'

module ExpressAdmin
  class SmartTreeTest < ActiveSupport::TestCase

    class Node
      attr :children, :name
      def initialize(name, children = [])
        @name = name
        @children = children
      end
    end

    def tree_item
      Node.new('Root', 
        [Node.new('Child1'),
         Node.new('Child2',
          [Node.new('Grandchild1'),
           Node.new('Grandchild2'),
           Node.new('Grandchild3')
           ])])
    end

    def tree_items
      [tree_item]
    end

    def expected
      "
<ul>
  <li>Child1</li>
  <li>Child2
    <ul>
      <li>Grandchild1</li>
      <li>Grandchild2</li>
      <li>Grandchild3</li>
    </ul>
  </li>
</ul>
"
    end

    test "smart_tree does something" do
      assert SmartTree.new(:category, "{{tree_item.name}}").compile
    end

    test "smart_tree outputs expected markup" do
      view_code = ExpressTemplates.compile {
        smart_tree(:tree_item) {
          "{{node.name}}"
        }
      }
      STDERR.puts view_code
      assert_equal expected.gsub(/\s+/, ''), eval(view_code)
    end


  end
end


