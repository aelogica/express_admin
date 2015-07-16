module ExpressAdmin
  class DefinitionTable < ExpressTemplates::Components::Configurable
    include ExpressTemplates::Components::Capabilities::Resourceful

    emits -> {
      table(class: 'definitions') {
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
      if @args.nil?
        definitions_from_hash(config)
      elsif @args.first.try(:kind_of?, Array)
        definitions_from_array(@args.first)
      end
    end

    def definitions_from_hash(hash)
      processed = hash.map do |k,v|
        if v.kind_of? Symbol
          [promptify(k), resource.send(v)]
        else
          [promptify(k), helpers.instance_eval("(#{v.source}).call(resource).to_s").html_safe]
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
