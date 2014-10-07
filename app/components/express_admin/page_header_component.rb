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
                h1 {
                  _yield
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


    using_logic { |c|
      _o = ''
      if content_for?(:page_header)
        _o << c._wrap_using(:header_wrap, self) {
          eval(c[:header])
        }
      end
      if content_for?(:page_header_lead)
        _o << c._wrap_using(:lead_wrap, self) {
          eval(c[:lead])
        }
      end
      _o.html_safe
    }


  end
end