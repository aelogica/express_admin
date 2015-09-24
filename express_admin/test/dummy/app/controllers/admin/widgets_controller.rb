module Admin
  class WidgetsController < ExpressAdmin::StandardController

    protected

      def resource_class
        ::Widget
      end

  end
end
