module ExpressAdmin
  class LayoutComponent < ExpressTemplates::Components::Configurable

    has_option :style, 'Add inline styles to the element'

    def style_attributes
      attribs = config[:style] || {}
      attribs.map do |k, v|
        "#{k}: #{v}"
      end.join('; ')
    end

  end
end
