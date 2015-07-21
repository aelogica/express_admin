module ExpressAdmin
  class Icon < ExpressTemplates::Components::Configurable
    emits -> {
      i(class: "icon ion-#{config[:id]}")
    }
  end
end