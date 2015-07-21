module ExpressAdmin
  class IconLink < ExpressTemplates::Components::Configurable

    emits -> {
      if config[:right]
        a(anchor_args) {
          text_node config[:text]
          icon(config[:icon_name].to_sym)
        }
      else
        a(anchor_args) {
          icon(config[:icon_name].to_sym)
          text_node config[:text]
        }
      end
    }

    def anchor_args
      args = {class: class_list, 
              href:  config[:href]}
      args[:id] = config[:id] if config[:id]
      args[:target] = config[:target] if config[:target]
      args['data-delete'] = config[:delete] if config[:delete]
      args['data-confirm'] = config[:confirm] if config[:confirm]
      args[:title] = config[:title] if config[:title]
      args
    end

    def icon_options
      [:icon_name, :text, :right]
    end

  end
end