module ExpressAdmin
  class LayoutComponent < ExpressTemplates::Components::Configurable

    def dom_id
      config.try(:[], :id)
    end

    def component_options
      [:id, :class, :style] + supported_style_options
    end

    def component_classes
      add_class config[:id].to_s
      add_class config[:class]
      class_names
    end

    def supported_style_options
      [:height, :width]
    end

    def provided_style_attributes
      config.select {|k,v| supported_style_options.include?(k) }
    end

    def style_attributes
      attribs = config[:style] || {}
      attribs.merge(provided_style_attributes).map do |k, v|
        "#{k}: #{v}"
      end.join('; ')
    end

    def pass_along_attributes
      config.reject {|k,v| component_options.include?(k) }
    end

    def container_div_attributes
      pass_along_attributes
        .merge(id: dom_id, class: component_classes)
        .merge(style: style_attributes)
    end

  end
end
