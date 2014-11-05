module ExpressAdmin
  class PageHeaderComponent < ExpressTemplates::Components::Base
    ETC = ExpressTemplates::Components

    class PageHeader < ExpressTemplates::Components::Base
      include ETC::Capabilities::Conditionality

      emits -> {
              h1 {
                content_for(:page_header)
              }
            }

      only_if -> { content_for?(:page_header) }

    end

    class PageHeaderLead < ExpressTemplates::Components::Base
      include ETC::Capabilities::Conditionality

      emits -> {
              p.lead {
                content_for(:page_header_lead)
              }
            }

      only_if -> { content_for?(:page_header_lead) }

    end

    emits -> {
        page_header
        page_header_lead
    }

  end


end