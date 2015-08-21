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

    test "nested resources should build from parent resource" do
      post :create, category_id: categories(:toys).to_param, widget: {column2: 'Cars'}

      response = get :index, category_id: categories(:toys).to_param
      assert_match /Lego/, response.body
      assert_match /Cars/, response.body
      refute_match /Hammer/, response.body
    end

  end
end
