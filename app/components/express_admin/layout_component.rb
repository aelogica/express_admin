module ExpressAdmin
  class LayoutComponent < ExpressTemplates::Components::Base
    include ExpressTemplates::Components::Capabilities::Configurable
    include ExpressTemplates::Components::Capabilities::Parenting

    def dom_id
      @config.try(:[], :id)
    end

    def classes
      ([macro_name] + (@config.try(:[], :class)||[])).join(" ")
    end
  end
end
