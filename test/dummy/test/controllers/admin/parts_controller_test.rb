require "test_helper"

module Admin
  class PartsControllerTest < ActionController::TestCase
    fixtures :all

    test "should get show" do
      get :show, category_id: categories(:toys).to_param, widget_id: widgets(:one).to_param, id: parts(:one).to_param
      assert_response :success
    end

    test "should display the nested index" do
      response = get :index, category_id: categories(:toys).to_param, widget_id: widgets(:one).to_param
      assert_response :success
      assert_match /Some part/, response.body
      refute_match /Another part/, response.body
    end

  end
end
