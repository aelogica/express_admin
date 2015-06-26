module ExpressAdmin
  class SidebarRegion < LayoutComponent
    emits -> {
      div(dom_id, class: classes) {
        _yield
      }
    }

    def classes
      %w(sidebar-region).join @config.try(:[], :class)
    end
  end
end
