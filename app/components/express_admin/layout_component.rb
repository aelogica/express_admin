module ExpressAdmin
  class LayoutComponent < ExpressTemplates::Components::Configurable
    def dom_id
      config.try(:[], :id)
    end
  end
end
