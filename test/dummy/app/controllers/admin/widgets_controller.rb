module Admin
  class WidgetsController < AdminController

    defaults resource_class: Widget

    private

      def widget_params
        params.require(:widget).permit!
      end
  end
end
