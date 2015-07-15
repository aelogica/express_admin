module ExpressAdmin
  class MainRegion < ExpressTemplates::Components::Configurable
    emits -> (block) {
      div(class: 'main-region') {
        block.call(self) if block
      }
    }
  end
end
