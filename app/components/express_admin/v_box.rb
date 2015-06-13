require File.join(File.dirname(__FILE__), 'layout_component')
module ExpressAdmin
  class VBox < LayoutComponent

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
