require 'test_helper'

module Components

  class FlashMessagesTest < ActiveSupport::TestCase

    def helpers
      mock_action_view do
        def flash
          {notice: "Message"}
        end

      end
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