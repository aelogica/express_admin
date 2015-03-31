require "test_helper"

class AgentsTest < Capybara::Rails::TestCase
  test "sanity" do
    visit "/admin/dummy_engine/agents"
    assert_content page, "ExpressAdmin"
    refute_content page, "Welcome aboard"
    refute_content page, "Gravatar"
  end
end