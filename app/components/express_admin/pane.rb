require File.join(File.dirname(__FILE__), 'layout_component')

module ExpressAdmin
  class Pane < LayoutComponent

    emits -> {
      div(dom_id, class: classes) {
        heading if title || status
        _yield
      }
    }

    def heading
      h2.title {
        null_wrap { title }
        span.status(status) if status
      }
    end

    def dom_id
      nil
    end

    def title
      @config[:title] || ''
    end

    def status
      @config[:status] || nil
    end

    def classes
      super << " #{@config[:id]}"
    end

  end
end
