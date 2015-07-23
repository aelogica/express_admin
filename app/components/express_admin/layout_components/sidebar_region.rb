module ExpressAdmin
  class SidebarRegion < LayoutComponent
    contains -> (block) {
      block.call(self) if block
    }
  end
end
