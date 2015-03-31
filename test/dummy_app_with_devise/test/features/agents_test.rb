require "test_helper"

class AgentsTest < Capybara::Rails::TestCase
  test "sanity" do
    visit "/admin/dummy_engine/agents"
    within "#new_user" do
      fill_in "Email", with: "admin@example.com"
      fill_in "Password", with: "passw0rd"
      click_button "Log in"
    end
    assert_content page, "ExpressAdmin"
    refute_content page, "Welcome aboard"
  end
end
