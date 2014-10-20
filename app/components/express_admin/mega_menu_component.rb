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

    fragments menu_item: -> {
                        li {
                          a(href: "{{eval(menu.main.path)}}") {
                            i.icon(class: '{{"icon-express_#{menu.main.title.downcase}"}}')
                            span "{{menu.main.title}}"
                          }
                        }
                      },

              empty_state: -> {
                div._empty_state_wrapper {
                  p.lead._text_muted "No modules added yet."
                }
              },

              menu_wrapper: -> {
                li.megamenu._has_dropdown {
                  a("Manage", href: '#', onClick: 'return false;')
                  ul.dropdown._dropdown_wrapper {
                    li._megamenu_overlay {
                      div._megamenu_container {
                        h1 "Modules"
                        nav {
                          ul {
                            _yield
                          }
                        }
                        # render(partial: 'shared/express_admin/express_admin_extra_menu') rescue nil
                      }
                    }
                  }
                }
              }

    for_each -> {admin_menus}, as: 'menu', emit: :menu_item, empty: :empty_state

    wrap_with :menu_wrapper, dont_wrap_if: -> { admin_menus.empty? }

  end
end
