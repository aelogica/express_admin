require 'test_helper'

module ExpressAdmin
  class SmartTreeTest < ActiveSupport::TestCase

    class Node
      attr :children
      def initialize(name, children = [])
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

    def expected
      "
<ul id=\"tree_item\" class=\"tree_items tree\">
  <li>{{tree_item.name}}</li>
  <li>{{tree_item.name}}
    <ul id=\"tree_item\" class=\"tree_items tree\">
      <li>{{tree_item.name}}</li>
      <li>{{tree_item.name}}</li>
      <li>{{tree_item.name}}</li>
    </ul>
  </li>
</ul>
"
    end

    test "smart_tree does something" do
      assert SmartTree.new(:category, "{{tree_item.name}}").compile
    end

    test "smart_tree outputs expected markup" do
      code = SmartTree.new(:tree_item).compile
      assert_equal expected, eval(code)
    end


  end
end


