module ExpressAdmin
  module Components
    module Presenters
      class DefinitionTable < DefinitionList
        include ExpressTemplates::Components::Capabilities::Resourceful

        tag :table

        contains -> {
          tbody {
            definitions.each do |label, content|
              tr {
                th(align: "right") { label }
                td { content }
              }
            end
          }
        }

      end
    end
  end
end
