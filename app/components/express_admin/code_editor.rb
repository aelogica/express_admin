module ExpressAdmin
  class CodeEditor < ExpressTemplates::Components::Forms::FormComponent

    has_option :mode, "Language of the editor", type: :string
    has_option :rows, "Define the number of rows", type: :int, default: 10

    contains -> {
      base_styles = "position: relative; height: 300px;"
      text_area_tag object, object.send(field), field_helper_options.merge( id: field_id, name: field_name ) #field_name_attribute, field_helper_options
      content_tag(:div, '', id: "ace_#{field_name}",
                  class: "ace-input", style: base_styles,
                  data: { target: field_id, mode: config[:mode] })
    }

    def field_helper_options
      {rows: rows, class: "hide", hidden: true}.merge(super)
    end

    def object
      self.send resource_name
    end

    def field
      config[:id]
    end

    def rows
      config[:rows]
    end

    def field_name
      "#{object_type}[#{field}]"
    end

    def field_id
      "#{object_type}_#{field}_#{object.id}"
    end

    def object_type
      object.class.to_s.demodulize.underscore
    end
  end
end

