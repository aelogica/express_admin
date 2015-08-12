module Admin
  class CategoriesController < ExpressAdmin::StandardController

    protected

      def resource_class
        ::Category
      end

  end
end
