module ExpressAdmin
  class AdminMenusComponent < ExpressTemplates::Components::Base
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
                nav {
                  ul {
                    _yield
                  }
                }
              }

    # for_each -> {admin_menus}, as: 'menu', emit: :menu_item

    # wrap_with :menu_wrapper

    for_each = -> (c) {
      s = admin_menus.map do |menu|
        eval(c[:menu_item])
      end.join()
      binding.pry
      s
    }

    using_logic do |c|
      if admin_menus.any?
        c._wrap_using(:menu_wrapper, self, &for_each)
        # c.render(self)
      else
        c.render(:empty_state, self)
      end
    end

  end
end
