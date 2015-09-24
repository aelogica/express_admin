module ExpressAdmin
  module Components
    module Layout

      class Pane < LayoutComponent

        has_option :title, 'The title of the pane', default: ''
        has_option :status, 'Status of the pane'

        prepends -> {
          heading if title || status
        }

        def heading
          h4(class: 'pane-title') {
            current_arbre_element.add_child title
            if status
              span(class: 'pane-status') { status }
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
  end
end
