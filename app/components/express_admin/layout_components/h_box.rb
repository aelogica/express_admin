module ExpressAdmin
  class HBox < LayoutComponent
    contains -> (&block) {
      block.call(self) if block
    }
  end
end
