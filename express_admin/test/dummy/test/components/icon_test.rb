require 'test_helper'

module Components

  class IconTest < ActiveSupport::TestCase

    def assigns
      {}
    end

    def helpers
      mock_action_view
    end

    def rendered_icon(*args)
      arbre {
        icon(*args)
      }
    end

    test "accepts string as input for icon name as id" do
      assert_match /i class="icon ion-beer"/, rendered_icon("beer")
    end

    test "accepts symbol as input for icon name as id" do
      assert_match /i class="icon ion-beer"/, rendered_icon(:beer)
    end

  end

end
