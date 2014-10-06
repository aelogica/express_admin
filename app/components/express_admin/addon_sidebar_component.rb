module ExpressAdmin
  class AddonSidebarComponent < ExpressTemplates::Components::Base
  # Replaces:
  #
  # .sidebar-wrapper
  #   %aside.sidebar
  #     %h5.title= ExpressData::Engine.express_admin_menu.name
  #     %ul.side-nav
  #       - ExpressData::Engine.express_admin_menu.items.each do |item|
  #         %li
  #           = link_to item.name, eval(item.path)

    helper(:menu_name) { current_module.express_admin_menu.name }

    helper(:menu_link) { link_to item.name, item.path }



    emits menu_item:    -> {
                             li { menu_link }
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
    for_each -> { current_module.express_admin_menu.items }, emit: :menu_item

    wrap_with :menu_wrapper

  end
end