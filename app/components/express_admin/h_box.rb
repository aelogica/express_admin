require File.join(File.dirname(__FILE__), 'layout_component')
module ExpressAdmin
  class HBox < LayoutComponent

    emits -> {
      div(dom_id, class: classes) {
        _yield
      }
    }

    def classes
      super + ' container'
    end

  end
end
