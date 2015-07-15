module ExpressAdmin
  class PageHeaderComponent < ExpressTemplates::Components::Base
    ETC = ExpressTemplates::Components

    class PageHeader < ExpressTemplates::Components::Base
      emits -> {
        h1 {
          content_for(:page_header) if content_for?(:page_header)
        }
      }
    end

    class PageHeaderLead < ExpressTemplates::Components::Base
      emits -> {
        p(class: 'lead') {
          content_for(:page_header_lead) if content_for?(:page_header_lead)
        }
      }
    end

    emits -> {
        page_header
        page_header_lead
    }

  end


end