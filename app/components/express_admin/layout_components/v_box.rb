module ExpressAdmin
  class VBox < LayoutComponent
    contains -> (&block) {
      block.call(self) if block
    }
  end
end
