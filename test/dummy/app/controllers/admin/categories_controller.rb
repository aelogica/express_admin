module Admin
  class CategoriesController < AdminController

    defaults resource_class: Category

    private

      def category_params
        params.require(:category).permit!
      end
  end
end
