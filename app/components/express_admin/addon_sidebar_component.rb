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

    emits -> {
       section(class: 'module-sidebar') {
         ul(class: 'menu-items') {
           li(class: 'title') { current_menu_name }
           helpers.current_menu.items.each do |item|
             li {
               link_to item.title, helpers.instance_eval(item.path)
             }
           end
         }
       }
     }

  end
end
