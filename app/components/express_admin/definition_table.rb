module ExpressAdmin
  class DefinitionTable < ExpressTemplates::Components::Configurable
    include ExpressTemplates::Components::Capabilities::Resourceful

    emits -> {
      table.definitions {
        tbody {
          definitions.each do |label, content|
            tr {
              th(align: "right") { label }
              td { content }
            }
          end
        }
      }
    }

    def definitions
      if @args.first.kind_of?(Array)
        definitions_from_array(@args.first)
      elsif @args.first.kind_of?(Hash)
        definitions_from_hash(@args.first)
      end
    end

    def definitions_from_hash(hash)
      processed = hash.map do |k,v|
        if v.kind_of? Symbol
          [promptify(k), "{{resource.#{v}}}"]
        else
          [promptify(k), v]
        end
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
