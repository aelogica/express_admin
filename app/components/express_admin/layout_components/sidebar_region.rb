module ExpressAdmin
  class SidebarRegion < LayoutComponent
    emits -> (block) {
      add_class('sidebar-region')
      add_class(config.try(:[], :class))
      div(attributes.merge(id: dom_id)) {
        block.call(self) if block
      }
    }
  end
end
