require 'test_helper'

module ExpressAdmin

  class DefinitionTableTest < ActiveSupport::TestCase

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

    def deftable(*args)
      arbre {
        definition_table(:deftable, *args)
      }.to_s
    end

    DEFTABLE_MARKUP = <<-HTML
<table class="definition-table" id="deftable">
  <tbody>
    <tr>
      <th align="right">Term1:</th>
      <td>def1</td>
    </tr>
    <tr>
      <th align="right">Term2:</th>
      <td>def2</td>
    </tr>
    <tr>
      <th align="right">Term3:</th>
      <td>def3</td>
    </tr>
  </tbody>
</table>
HTML

    DEFTABLE_MARKUP_ARR = <<-HTML
<table class="definition-table" id="deftable">
  <tbody>
    <tr>
      <th align="right">Field1:</th>
      <td>{{resource.field1}}</td>
    </tr>
    <tr>
      <th align="right">Field2:</th>
      <td>{{resource.field2}}</td>
    </tr>
  </tbody>
</table>
HTML

    test "definition_table renders correct markup with hash input" do
      assert_equal DEFTABLE_MARKUP, deftable(list_types[:hash])
    end

    test "definition_table renders correct markup with array input" do
      assert_equal DEFTABLE_MARKUP_ARR, deftable(list_types[:array])
    end

  end
end