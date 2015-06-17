module ExpressAdmin
  class MainRegion < ExpressTemplates::Components::Container
    emits -> {
      div._main_region {
        _yield
      }
    }
  end
end
