module ExpressAdmin
  class SidebarRegion < LayoutComponent
    emits -> (block) {
      add_class('sidebar-region')
      add_class(config.try(:[], :class))
      div(id: dom_id, class: class_names) {
        block.call(self) if block
      }
    }
  end
end
