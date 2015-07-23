module ExpressAdmin
  class MainRegion < ExpressTemplates::Components::Configurable
    contains -> (&block) {
      block.call(self) if block
    }
  end
end
