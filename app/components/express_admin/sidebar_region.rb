module ExpressAdmin
  class SidebarRegion < ExpressTemplates::Components::Container
    emits -> {
      div._sidebar_region {
        _yield
      }
    }
  end
end
