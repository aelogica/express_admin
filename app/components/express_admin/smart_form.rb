require 'rails/generators/generated_attribute'
module ExpressAdmin
  class SmartForm < ExpressTemplates::Components::Base
    include ExpressTemplates::Components::Capabilities::Configurable

    emits -> {
      express_form(form_args) {
        attributes.each do |attrib|
          form_field_for(attrib)
        end
        submit(class: "button right tight tiny")
      }
    }

    TIMESTAMPS = ['updated_at', 'created_at']

    def form_field_for(attrib)
      field_type_substitutions = {'text_area'       => 'textarea',
                                  'datetime_select' => 'datetime',
                                  'check_box'       => 'checkbox'}
      field_type = attrib.field_type.to_s.sub(/_field$/,'')
      case
      when attrib.name.eql?('id')
        hidden(:id)
      when TIMESTAMPS.include?(attrib.name)
        div {
          label {
            "#{attrib.name.titleize}: {{@#{resource_name}.try(:#{attrib.name})}}"
          }
        }
      else
        if attrib.name.match(/_id$/)
          select(attrib.name)
        else
          self.send((field_type_substitutions[field_type] || field_type), attrib.name.to_sym)
        end
      end
    end


    protected

      def form_args
        {           id: resource_name,
                action: action_path,
         resource_name: resource_name }
      end

      def action_path
        "{{resource.persisted? ? resource_path(resource.id) : collection_path}}"
      end

      def resource_name
        @config[:id].to_s.singularize
      end

      def columns
        resource_class.constantize.columns
      end

      def attributes
        columns.map do |attrib|
          field_definition = [attrib.name, attrib.type] # index not important here for now
          Rails::Generators::GeneratedAttribute.parse(field_definition.join(":"))
        end
      end

      def resource_class
        # TODO: Module namespace needs to be guessed somehow
        @config[:class_name] || "ExpressCms::#{resource_name.classify}"
      end

  end
end
