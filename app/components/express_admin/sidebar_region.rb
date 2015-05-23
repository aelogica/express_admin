module ExpressAdmin
  class SidebarRegion < ExpressTemplates::Components::Container
    emits -> {
      div(:sidebar)._large_4.columns {
        div._container {
          _yield
        }
      }
    }
  end
end
