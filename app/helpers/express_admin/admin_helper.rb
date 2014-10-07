module ExpressAdmin
  module AdminHelper

    include ExpressMedia::Admin::MediaHelper if Kernel.const_defined?("ExpressMedia::Engine")

    def title_partial
      (ExpressAdmin::Engine.config.title_partial rescue nil) || 'shared/express_admin/title'
    end

    def title_partial_or_express_admin
      render(title_partial) rescue 'ExpressAdmin'
    end

    def sign_in_or_sign_out
      if self.respond_to?(:user_signed_in?)
        if user_signed_in?
          link_to 'Sign out', main_app.destroy_user_session_path, method: :delete
        else
          link_to 'Sign in', main_app.user_session_path
        end
      end
    end

    def current_module
      controller.class.to_s.split('::').first.constantize
    end

    def current_module_path_name
      current_module.to_s.underscore
    end

    def current_engine
      "#{current_module}::Engine".constantize
    end

    def current_menu
      current_engine.express_admin_menu
    end

    def current_menu_name
      current_menu.name || current_menu.title || current_menu.main.try(:title)
    end

    def current_user_gravatar(size=40)
      image_tag("#{gravatar_image_url(current_user.email) rescue nil}?s=#{size}")
    end

    def title_content
      content_for?(:title) ? yield(:title) : Rails.application.class.parent_name.underscore.titleize
    end

    def description_meta_content
      content_for?(:description) ? yield(:description) : 'Testapp'
    end

    def admin_javascript_and_css_includes
      current_module_path = current_module.to_s.underscore unless current_module.eql?(ExpressAdmin)
      a = []
      a << stylesheet_link_tag("express_admin/application")
      a << stylesheet_link_tag("#{current_module_path}/admin/application") if current_module_path
      a << stylesheet_link_tag("app_express/application") if defined?(AppExpress)
      a << javascript_include_tag("express_admin/application", 'data-turbolinks-track' => true)
      a << javascript_include_tag("#{current_module_path}/application", 'data-turbolinks-track' => true) if current_module_path
      a.join()
    end


    def admin_menus
      ExpressAdmin::Engine.all_rails_engines.
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

    def flash_class(key)
      case key
      when 'notice' then 'info'
      when 'success' then 'success'
      when 'alert' then 'warning'
      when 'error' then 'alert'
      end
    end
  end
end
