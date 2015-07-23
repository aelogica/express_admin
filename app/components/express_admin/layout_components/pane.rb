module ExpressAdmin
  class Pane < LayoutComponent

    has_option :title, 'The title of the pane', default: ''
    has_option :status, 'Status of the pane'

    contains -> (block) {
      heading if title || status
      block.call(self) if block
    }

    def heading
      h4(class: 'title') {
        current_arbre_element.add_child title
        if status
          span(class: 'status') { status }
        end
      }
    end

  end
end
