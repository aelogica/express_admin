module ExpressAdmin
  class MainRegion < ExpressTemplates::Components::Container
    emits -> {
      div(:main) {
        _yield
      }
    }
  end
end
