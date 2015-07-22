module ExpressAdmin
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
      if config[:for].kind_of?(Array)
        definitions_from_array(@args.first)
      elsif config[:for].kind_of?(Hash)
        definitions_from_hash(@args.first)
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
