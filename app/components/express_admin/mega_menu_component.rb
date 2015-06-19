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

    helper(:extra_menu) {
      render(partial: 'shared/express_admin/express_admin_extra_menu') rescue nil
    }

    fragments menu_item: -> {
                        li {
                          a(href: "{{eval(menu.path)}}") {
                            i.icon(class: "icon-express_{{menu.title.downcase}}")
                            span "{{menu.title}}"
                          }
                        }
                      },

              empty_state: -> {
                p.lead._text_muted "No modules added yet."
              },

              menu_wrapper: -> {
                li._has_sub_menu {
                  a._sub_menu_expander(href: '#', onClick: 'return false;') {
                    span.item { 'Manage' }
                    i._ion_arrow_down_b
                  }
                  div._sub_menu.hidden {
                    ul._sub_menu_items {
                      li.title { 'Modules' }
                      _yield
                    }
                    ul._sub_menu_items {
                      extra_menu
                    }
                  }
                }
              }

    for_each -> {admin_menus}, as: 'menu', emit: :menu_item, empty: :empty_state

    wrap_with :menu_wrapper, dont_wrap_if: -> { admin_menus.empty? }

  end
end
