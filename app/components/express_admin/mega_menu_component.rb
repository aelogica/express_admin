module ExpressAdmin
  class MegaMenuComponent < ExpressTemplates::Components::Base
    # %h1 "Modules"

    # - if admin_menus.any?
    #   %nav
    #     %ul
    #       - admin_menus.each do |menu|
    #         %li
    #           = link_to eval(menu.main.path) do
    #             %i.icon{class: "icon-express_#{menu.main.title.downcase}"}
    #             %span= menu.main.title
    # - else
    #   .empty-state-wrapper
    #     %p.lead.text-muted No modules added yet.
    #     %p
    #       = link_to app_express.addons_path, class: 'button success radius' do
    #         %span.icon.ion-plus
    #           Add Module

    emits -> {
      menu_wrapper {
        if helpers.admin_menus.any?
          helpers.admin_menus.each do |menu|
            menu_item(menu)
          end
        else
          para(class: 'lead text-muted') {
            "No modules added yet."
          }
        end
      }
    }

    def extra_menu
      render(partial: 'shared/express_admin/express_admin_extra_menu') rescue nil
    end

    def menu_item(menu)
      li {
        a(href: helpers.instance_eval(menu.path)) {
          i(class: "icon icon-express_#{menu.title.gsub(/\s+/, '').underscore}")
          span menu.title
        }
      }
    end

    def menu_wrapper
      li(class: "has-sub-menu") {
        a(class: "sub-menu-expander", href: '#', onClick: 'return false;') {
          span(class: 'item') {'Manage' }
          i(class: "ion-arrow-down-b")
        }
        div(class: 'sub-menu hidden') {
          ul(class: 'sub-menu-items') {
            li(class: 'title') { 'Modules' }
            yield
          }
          ul(class: 'sub-menu-items') {
            extra_menu
          }
        }
      }
    end

  end
end
