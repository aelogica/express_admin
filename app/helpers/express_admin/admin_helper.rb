module ExpressAdmin
  module AdminHelper

    include ExpressMedia::Admin::MediaHelper if Kernel.const_defined?("ExpressMedia::Engine")

    def title_partial
      (ExpressAdmin::Engine.config.title_partial rescue nil) || 'shared/express_admin/title'
    end

    def admin_menus
      ExpressAdmin::Engine.all_rails_engines.
        select {|engine| engine.methods.include?(:express_admin_menu) }.
        map {|engine| engine.express_admin_menu}
    end

    def admin_navbar_items
      admin_navbar = RecursiveOpenStruct.new()
      admin_navbar.title_partial = render title_partial
      admin_navbar.profile_partial = render 'shared/express_admin/navigation_bar_profile'
      admin_navbar.menus = admin_menus.map do |menu|
        if menu.submenus
          menu.main.path = '#' # for dropdown
          menu.submenus.each do |submenu|
            submenu.path = eval(submenu.path)
          end
        else
          menu.main.path = eval(menu.main.path)
        end

        menu
      end

      admin_navbar.to_json
    end

    def admin_navbar
      if current_user
        (stylesheet_link_tag 'express_admin/sections/_header') +
        (stylesheet_link_tag 'express_admin/shared/_navigation') +
        content_tag(:div, id: 'appexpress-admin-navbar') do
          content_tag(:script) do
            "window.appexpress_admin_navbar = #{admin_navbar_items}".html_safe
          end
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
