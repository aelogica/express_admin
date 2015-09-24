module ExpressAdmin
  class WidgetBox < ExpressTemplates::Components::Configurable

    has_option :title, 'The title to be displayed.'

    contains -> (&block) {
      header(class: 'title') { box_title }
      div(class: 'widget-body') {
        block.call(self) if block
      }
    }

    before_build -> {
      set_attribute(:id, "#{config[:id].to_s.dasherize}-box")
    }

    protected

      def resource_title
        config[:id].to_s.titleize
      end

      def box_title
        config[:title] || (resource.persisted? ? "Edit #{resource_title}" : "New #{resource_title}")
      end

      def resource
        self.send(config[:id])
      end
  end
end
