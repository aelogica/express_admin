require File.join(File.dirname(__FILE__), 'layout_component')

module ExpressAdmin
  class Pane < LayoutComponent

    emits -> (block) {
      div(container_div_attributes) {
        heading if title || status
        block.call(self) if block
      }
    }

    def heading
      h4(class: 'title') {
        current_arbre_element.add_child title
        if status
          span(class: 'status') { status }
        end
      }
    end

    def dom_id
      nil
    end

    def title
      config[:title] || ''
    end

    def status
      config[:status] || nil
    end

    def component_options
      super +
        [:title, :status]
    end

  end
end
