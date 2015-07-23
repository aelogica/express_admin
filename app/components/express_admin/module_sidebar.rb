module ExpressAdmin
  # renders a sidebar partial if one is available
  # otherwise uses menu.yml
  class ModuleSidebar < ExpressTemplates::Components::Base
    tag :section

    contains -> {
      ul(class: 'menu-items') {
        li(class: 'title') { current_menu_name }
        menu_list(helpers.current_menu.items)
      }
    }

    def build(*args, &block)
      begin
        render("shared/#{helpers.current_module_path_name}/sidebar")
      rescue Exception => e
        super(*args, &block)
      end
    end

    def menu_list(list)
      list.each do |item|
        menu_list_item(item)
      end
    end

    def menu_list_item(item)
      li {
        link_to item.title.html_safe, helpers.instance_eval(item.path)
      }
    end
  end
end
