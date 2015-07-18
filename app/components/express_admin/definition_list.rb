module ExpressAdmin
  class DefinitionList < ExpressTemplates::Components::Configurable
    include ExpressTemplates::Components::Capabilities::Resourceful

    emits -> {
      dl {
        definitions.each do |label, content|
          dt { label }
          dd { content }
        end
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
          [k, resource.send(v)]
        else
          [k, v]
        end
      end
      Hash[processed]
    end

    def definitions_from_array(fields)
      Hash[fields.map {|field| ["#{field.to_s.titleize}:", resource.send(field)]}]
    end

  end
end
