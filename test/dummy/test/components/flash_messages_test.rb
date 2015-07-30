require 'test_helper'

module Components

  class FlashMessagesTest < ActiveSupport::TestCase

    def assigns
      { flash: flash }
    end

    def flash
      {notice: "Message"}
    end

    def helpers
      view = mock_action_view(assigns)
    end

    def flashmsg
      arbre {
        flash_messages
      }
    end

    test "renders" do
      assert flashmsg
    end

    test "shows correct flash message" do
      assert_match /<span>Message<\/span>/, flashmsg
    end

  end

end