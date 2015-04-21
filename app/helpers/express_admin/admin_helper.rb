module ExpressAdmin
  module AdminHelper

    # TODO move this out
    #include ExpressMedia::Admin::MediaHelper if Kernel.const_defined?("ExpressMedia::Engine")

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
      ExpressAdmin::Menu[current_module_path_name]
    end

    def current_menu_name
      current_menu.title
    end

    def current_user_gravatar
      if defined?(current_user) && !current_user.nil?
        gravatar_image_tag current_user.email
      end
    end

    def title_content
      content_for?(:title) ? yield(:title) : Rails.application.class.parent_name.underscore.titleize
    end

    def description_meta_content
      content_for?(:description) ? yield(:description) : 'Testapp'
    end

    def admin_javascript_and_css_includes
      current_module_path = current_module.to_s.underscore
      a = []
      a << stylesheet_link_tag("#{current_module_path}/admin/application")
      a << stylesheet_link_tag("app_express/admin/application") if defined?(AppExpress)
      a << javascript_include_tag("#{current_module_path}/admin/application", 'data-turbolinks-track' => true)
      a.join()
    end

    def admin_menus
      addons = ExpressAdmin::Engine.all_addons.map do |engine|
        ExpressAdmin::Menu[engine.addon_name.to_s] rescue nil
      end.compact

      addons.sort do |addonA, addonB|
        if addonA.position == addonB.position
          addonA.title <=> addonB.title
        else
          addonA.position <=> addonB.position
        end
      end
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
