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
                               link_to "{{(item.title)}}", "{{eval(item.path)}}"
                             }
                           },

          menu_wrapper: -> {
                             div._sidebar_wrapper {
                               aside.sidebar {
                                 h1 {
                                   menu_name
                                 }
                                 ul {
                                   _yield
                                 }
                               }
                             }
                           }

    # for_each -> { current_menu.items || [] }, as: :item, emit: :menu_item

    wrap_with :menu_wrapper

    menu_items = -> (c) {
      (current_menu.items || []).map do |item|
        eval(c[:menu_item])
      end.join
    }

    using_logic do |c|
      begin
        render(partial: "shared/#{current_module_path_name}/sidebar")
      rescue => e
        c._wrap_it(self, &menu_items)
      end
    end

  end
end