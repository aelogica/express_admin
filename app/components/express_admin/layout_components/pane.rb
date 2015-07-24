module ExpressAdmin
  class Pane < LayoutComponent

    has_option :title, 'The title of the pane', default: ''
    has_option :status, 'Status of the pane'

    prepends -> {
      heading if title || status
    }

    def heading
      h4(class: 'title') {
        current_arbre_element.add_child title
        if status
          span(class: 'status') { status }
        end
      }
    end

    def title
      config[:title]
    end

    def status
      config[:status]
    end

  end
end
