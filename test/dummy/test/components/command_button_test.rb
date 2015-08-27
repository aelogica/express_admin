require 'test_helper'

module Components

  class CommandButtonTest < ActiveSupport::TestCase

    def assigns
      {}
    end

    def helpers
      mock_action_view do
        def twiddle_widget_path(id)
          "/widgets/#{id}/twiddle"
        end
      end
    end

    def command_button(*args)
      arbre(widget: widgets(:one)) {
        command_button(*args)
      }
    end

    test "command button creates a form with a submit button having the correct name" do
      assert_match /form.*action="\/widgets\/\d+\/twiddle"/, command_button(:twiddle, resource_name: :widget)
      assert_match /input type="submit" value="twiddle"/, command_button(:twiddle, resource_name: :widget)
    end

    def command_button_list(*args)
      arbre(widget: widgets(:one)) {
        command_button_list(*args)
      }
    end

    test "command_button_list creates a list of command buttons" do
      assert_match /ul class="command-button-list"/, command_button_list(:widget)
      assert_match /li.*<form.*\<\/li>/, command_button_list(:widget).split("\n").join
    end

  end

end
