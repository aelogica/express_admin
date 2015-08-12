require 'test_helper'

module Admin
  class WidgetsControllerTest < ActionController::TestCase
    fixtures :all

    test "should get show" do
      get :show, category_id: categories(:toys).to_param, id: widgets(:one).to_param
      assert_response :success
    end

    test "should display the nested index" do
      response = get :index, category_id: categories(:toys).to_param
      assert_response :success
      assert_match /Lego/, response.body
      refute_match /Hammer/, response.body
    end

  end
end
