module ExpressAdmin
  class Vertical < LayoutComponent

    emits -> (contents) {
      div(container_div_attributes) {
        contents.call(self) if contents
      }
    }
  end
end