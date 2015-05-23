module ExpressAdmin
  class MainRegion < ExpressTemplates::Components::Container
    emits -> {
      div(:main)._large_8.columns {
        _yield
      }
    }
  end
end
