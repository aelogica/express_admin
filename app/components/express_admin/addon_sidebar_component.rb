module ExpressAdmin
  class AddonSidebarComponent < ExpressTemplates::Components::Base
  # Replaces:
  #
  # .sidebar-wrapper
  #   %aside.sidebar
  #     %h5.title= <addon>::Engine.express_admin_menu.name
  #     %ul.side-nav
  #       - <addon>::Engine.express_admin_menu.items.each do |item|
  #         %li
  #           = link_to item.name, eval(item.path)

    helper :menu_name, &-> { current_menu_name }

    emits menu_item:    -> {
                             li {
                               link_to "{{item.title}}", "{{eval(item.path)}}"
                             }
                           },

          menu_wrapper: -> {
                             section._module_sidebar {
                               ul._menu_bar.vertical {
                                 li.title { menu_name }
                                 _yield
                               }
                             }
                           }

    for_each -> { current_menu.items || [] }, as: :item, emit: :menu_item

    wrap_with :menu_wrapper

    def compile
      %Q(begin
        render(partial: "shared/\#\{current_module_path_name\}/sidebar")
      rescue => e
        #{super}
      end)
    end

  end
end
