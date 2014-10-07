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
                              link_to "{{(item.name||item.title)}}", "{{eval(item.path)}}"
                             }
                           },

          menu_wrapper: -> {
                             div._sidebar_wrapper {
                               aside.sidebar {
                                 h5.title {
                                   menu_name
                                 }
                                 ul._side_nav {
                                   _yield
                                 }
                               }
                             }
                           }
    for_each -> { current_menu.items }, as: :item, emit: :menu_item

    wrap_with :menu_wrapper

  end
end