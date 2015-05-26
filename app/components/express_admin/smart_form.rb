require 'rails/generators/generated_attribute'
require File.expand_path('../smart_support', __FILE__)

module ExpressAdmin
  class SmartForm < ExpressTemplates::Components::Base
    include ExpressTemplates::Components::Capabilities::Configurable

    include SmartSupport

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
        @config[:action] ||
        "{{@#{resource_name}.try(:persisted?) ? #{resource_path} : #{collection_path}}}"
      end

      def attributes
        columns.map do |attrib|
          field_definition = [attrib.name, attrib.type] # index not important here for now
          Rails::Generators::GeneratedAttribute.parse(field_definition.join(":"))
        end
      end

  end
end
