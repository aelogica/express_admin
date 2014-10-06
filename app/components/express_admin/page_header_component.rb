module ExpressAdmin
  class PageHeaderComponent < ExpressTemplates::Components::Base
      # if content_for?(:page_header)
      #   .row.page-header
      #     %h1
      #       = yield :page_header
      #     - if content_for?(:page_header_lead)
      #       %p.lead
      #         = yield :page_header_lead

    emits header_wrap: -> {
              div.row._page_header {
                h1 {
                  _yield
                }
              }

            },
          lead_wrap: -> {
              p.lead {
                _yield
              }
            },
          header: -> {
            content_for(:page_header)
          },
          lead: -> {
            content_for(:page_header_lead)
          }


    using_logic {
      if content_for?(:page_header)
        c._wrap_using(:header_wrap, self, c[:header])
      end
      if content_for?(:page_header_lead)
        c._wrap_using(:lead_wrap, self, c[:lead])
      end
    }

  end
end