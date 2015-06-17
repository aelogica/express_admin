require File.join(File.dirname(__FILE__), 'layout_component')

module ExpressAdmin
  class Pane < LayoutComponent

    emits -> {
      div(dom_id, class: classes) {
        header if title || status
        _yield
      }
    }

    def header
      div.header {
        h2(title)
        div.status(status)
      }
    end

    def dom_id
      nil
    end

    def title
      @config[:title] || ''
    end

    def status
      @config[:status] || ''
    end

    def classes
      super << " #{@config[:id]}"
    end

  end
end
