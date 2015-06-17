module ExpressAdmin
  class WidgetBox < ExpressTemplates::Components::Column
    emits -> {
      div._widget_box(id: "#{my[:id].to_s.dasherize}-box") {
        header.title(box_title)
        div._widget_body {
          _yield
        }
      }
    }

    protected

      def resource_name
        my[:id].to_s.titleize
      end

      def box_title
        "{{resource.persisted? ? 'Edit #{resource_name}' : 'New #{resource_name}'}}"
      end
  end
end
