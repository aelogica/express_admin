require File.join(File.dirname(__FILE__), 'layout_component')
module ExpressAdmin
  class Horizontal < LayoutComponent

    emits -> (contents) {
      div(container_div_attributes) {
        contents.call(self) if contents
      }
    }
  end
end