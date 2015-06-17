module ExpressAdmin
  class SidebarRegion < ExpressTemplates::Components::Container
    emits -> {
      div(:sidebar) {
        div._container {
          _yield
        }
      }
    }
  end
end
