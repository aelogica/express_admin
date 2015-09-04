module ExpressAdmin
  class LayoutComponent < ExpressTemplates::Components::Container

    has_option :style, 'Add inline styles to the element'

    before_build {
      set_attribute :style, style_attributes
    }

    def style_attributes
      attribs = config[:style] || {}
      attribs.map do |k, v|
        "#{k}: #{v}"
      end.join('; ')
    end

  end
end
