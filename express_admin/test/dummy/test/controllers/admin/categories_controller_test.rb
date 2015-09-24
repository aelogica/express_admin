require 'test_helper'

module Admin
  class CategoriesControllerTest < ActionController::TestCase
    fixtures :all

    test 'it should properly build and create resources' do
      post :create, category: {name: 'Songs'}

      category = Category.find_by_name 'Songs'
      assert_redirected_to admin_category_url category

      response = get :index
      assert_match /Songs/, response.body
    end
  end
end
