require 'test_helper'

module ExpressAdmin

  class DefinitionListTest < ActiveSupport::TestCase

    def assigns
    	{list_types: list_types}
    end

    def helpers
      mock_action_view(assigns)
    end

    def list_types
    	@list_types ||= OpenStruct.new(
    		array: ["field1", "field2"],
    		hash: {term1: "def1",
          		 term2: "def2",
          		 term3: "def3"})
    end	

    def deflist(*args)
    	arbre {
    		definition_list(:deflist, *args)
    	}.to_s
    end

    test "accepts array as input" do
    	assert deflist(list_types[:array])
    end

    test "accepts hash as input" do
      assert deflist(list_types[:hash])
    end

    test "uses keys as labels and values as definitions" do
      assert_match /<dt>Term1/, deflist(list_types[:hash])
    end

    DEFLIST_MARKUP_ARR = <<-HTML
<dl class="definition-list" id="deflist">
  <dt>Field1:</dt>
  <dd>{{resource.field1}}</dd>
  <dt>Field2:</dt>
  <dd>{{resource.field2}}</dd>
</dl>
HTML

    DEFLIST_MARKUP_HASH = <<-HTML
<dl class="definition-list" id="deflist">
  <dt>Term1:</dt>
  <dd>def1</dd>
  <dt>Term2:</dt>
  <dd>def2</dd>
  <dt>Term3:</dt>
  <dd>def3</dd>
</dl>
HTML

    test "definition_list renders correct markup with hash input" do
      assert_equal DEFLIST_MARKUP_HASH, deflist(list_types[:hash])
    end

    test "definition_list renders correct markup with array input" do
      assert_equal DEFLIST_MARKUP_ARR, deflist(list_types[:array])
    end 

  end

end