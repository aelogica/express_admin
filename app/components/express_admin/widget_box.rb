module ExpressAdmin
  class WidgetBox < ExpressTemplates::Components::Configurable
    emits -> (block) {
      div(class: 'widget-box', id: "#{config[:id].to_s.dasherize}-box") {
        header(class: 'title') { box_title }
        div(class: 'widget-body') {
          block.call(self) if block
        }
      }
    }

    protected

      def resource_name
        config[:id].to_s.titleize
      end

      def box_title
        config[:title] || (helpers.resource.persisted? ? "Edit #{resource_name}" : "New #{resource_name}")
      end
  end
end
