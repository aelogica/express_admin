require "test_helper"

module Admin
  class PartsControllerTest < ActionController::TestCase
    fixtures :all

    def setup
      @toy_category = categories(:toys).to_param
      @lego_widget = widgets(:one).to_param
      @some_part = parts(:one).to_param
    end

    test "should get show" do
      get :show, category_id: @toy_category, widget_id: @lego_widget, id: @some_part
      assert_response :success
    end

    test "should display the nested index" do
      response = get :index, category_id: @toy_category, widget_id: @lego_widget
      assert_response :success
      assert_match /Some part/, response.body
      refute_match /Another part/, response.body
    end

    test "nested resources should build from parent resource" do
      post :create, category_id: @toy_category, widget_id: @lego_widget, part: {name: 'Yellow'}

      response = get :index, category_id: @toy_category, widget_id: @lego_widget
      assert_match /Some part/, response.body
      assert_match /Yellow/, response.body
      refute_match /Another part/, response.body
    end

  end
end
