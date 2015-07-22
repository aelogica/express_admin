module ExpressAdmin
  class PageHeader < ExpressTemplates::Components::Base
    ETC = ExpressTemplates::Components

    contains -> {
      h1 {
        content_for(:page_header) if content_for?(:page_header)
      }
      para(class: 'lead') {
        content_for(:page_header_lead) if content_for?(:page_header_lead)
      }
    }
  end
end