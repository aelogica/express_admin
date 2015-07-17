module ExpressAdmin
  # renders a sidebar partial if one is available
  # otherwise uses menu.yml
  class AddonSidebarComponent < ExpressTemplates::Components::Base

    emits -> {
      begin
        render("shared/#{helpers.current_module_path_name}/sidebar")
      rescue Exception => e
        section(class: 'module-sidebar') {
          ul(class: 'menu-items') {
            li(class: 'title') { current_menu_name }
            li {
              menu_list(helpers.current_menu.items)
            }
          }
        }
      end
    }

    def menu_list(list)
      list.each do |item|
        menu_list_item(item)
      end
    end

    def menu_list_item(item)
      link_to item.title.html_safe, helpers.instance_eval(item.path)
    end

  end
end
