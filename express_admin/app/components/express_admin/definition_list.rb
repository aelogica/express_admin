module ExpressAdmin
  module Components
    module Presenters
      class DefinitionList < ExpressTemplates::Components::Configurable
        include ExpressTemplates::Components::Capabilities::Resourceful

        tag :dl

        list_types = {}
        list_types[:array] = {description: "List of fields on the current resource",
                              options: -> {resource.columns.map(&:name)}}
        list_types[:hash] = {description: "List of terms and definitions."}

        has_argument :list, "A list of things to define, presented as <label>: <definition>.",
                            as: :list, type: list_types

        contains -> {
          definitions.each do |label, content|
            dt { label }
            dd { content }
          end
        }

        def definitions
          if config[:list].kind_of?(Array)
            definitions_from_array(config[:list])
          elsif config[:list].kind_of?(Hash)
            definitions_from_hash(config[:list])
          end
        end

        def definitions_from_hash(hash)
          processed = hash.map do |k,v|
            value = if v.kind_of? Symbol
              resource.send(v)
            elsif v.respond_to?(:call)
              v.call(resource).html_safe
            else
              v
            end
            [promptify(k), value]
          end
          Hash[processed]
        end

        def definitions_from_array(fields)
          Hash[fields.map {|field| ["#{field.to_s.titleize}:", "{{resource.#{field}}}"]}]
        end

        private
          def promptify(k)
            if k.kind_of?(Symbol)
              k.to_s.promptify
            else
              k.to_s
            end
          end

      end
    end
  end
end