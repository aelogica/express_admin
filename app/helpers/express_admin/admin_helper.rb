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
  end
end
