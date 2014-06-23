module ExpressAdmin
  module AdminHelper

    def title_partial
      (ExpressAdmin::Engine.config.title_partial rescue nil) || 'layouts/express_admin/title'
    end

    def admin_menus
      Rails.application.eager_load!
      ::Rails::Engine.descendants.
        select {|engine| engine.methods.include?(:express_admin_menu) }.
        map {|engine| engine.express_admin_menu}
    end

    def menu_item(name, path)
      content_tag(:li, link_to(name, path), class: is_active?(path))
    end

    def is_active?(path)
      if request.path.eql?(path)
        "active"
      else
        nil
      end
    end

  end
end
