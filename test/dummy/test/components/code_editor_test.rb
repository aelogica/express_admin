require 'test_helper'

class Foo
  def self.columns; [] ; end
end

module Components

  class CodeEditorTest < ActiveSupport::TestCase

    def compiled_code_editor(*args)
       arbre {
        express_form(:foo){
          code_editor :name, *args
        }
      }
    end

    def assigns
      { foo: resource }
    end

    def helpers
      mock_action_view do
        def foos_path
          '/foos'
        end
      end
    end

    test "renders the code editor" do
      assert compiled_code_editor
    end

    test "div displays the ace editor" do
      assert_match 'class="ace-input"', compiled_code_editor
    end

    test "text area is hidden" do
      assert_match /textarea(.*?)class="hide" hidden="hidden"/, compiled_code_editor
    end

    test "rows can be changed" do
      assert_match 'rows="15"', compiled_code_editor(rows: 15)
    end

    test "language mode can be changed" do
      assert_match 'data-mode="html"', compiled_code_editor(mode: "html")
      assert_match 'data-mode="et"', compiled_code_editor(mode: "et")
    end

  end
end
