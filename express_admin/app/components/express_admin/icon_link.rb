module ExpressAdmin
  module Components
    module Navigation

      class IconLink < ExpressTemplates::Components::Configurable

        tag :a

        has_argument :id, "The name of the ionic icon withouth the ion- prefix. See http://ionicons.com/cheatsheet.html",
                         as: :icon_name,
                         type: [:symbol, :string]

        has_option :text,    "Link text to accompany the icon."

        has_option :right,   "Aligns the icon to the right of the text.",
                             default: false
        has_option :href,    "Link path, URL or anchor.",
                             default: '#', attribute: true
        has_option :title,   "Title text for accessibility; appears on mouse hover.",
                             attribute: true
        has_option :confirm, "Should trigger a confirm message.",
                             type: :boolean
        has_option :delete,  "Should perform a delete action.",
                             type: :boolean
        has_option :target,  "The link target attribute. Set to open in a new window or tab.",
                             attribute: true

        before_build -> {
          set_attribute 'data-method', 'delete' if config[:delete]
          set_attribute 'data-confirm', config[:confirm] if config[:confirm]
        }

        contains -> {
          if config[:right]
            text_node config[:text]
            icon(config[:icon_name].to_sym)
          else
            icon(config[:icon_name].to_sym)
            text_node config[:text]
          end
        }

      end
    end
  end
end
