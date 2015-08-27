module ExpressAdmin
  class PageHeader < ExpressTemplates::Components::Base

    contains -> {
      if content_for?(:page_header)
        h1 {
          content_for(:page_header)
        }
      end
      if content_for?(:page_header_lead)
        para(class: 'lead') {
          content_for(:page_header_lead)
        }
      end
    }
  end
end
