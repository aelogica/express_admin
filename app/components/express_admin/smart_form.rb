require 'rails/generators/generated_attribute'
module ExpressAdmin
  class SmartForm < ExpressTemplates::Components::Base
    include ExpressTemplates::Components::Capabilities::Configurable


# <% for attribute in attributes -%>

#            f.actions({
#              cancel: ['Cancel', {class: 'button radius tiny secondary cancel hide', href: '{{admin_blog_posts_path}}'}],
#              submit: ['Save', class: 'button tiny right radius ajax-submit', remote: true]
#            }, wrapper_class: 'form-group widget-buttons')

    emits -> {
      express_form(resource_name_for_path, resource_name: resource_name) {
        attributes.each do |attrib|
          form_field_for(attrib)
        end
        submit(class: "button right tight tiny")
      }
    }

    def form_field_for(attrib)
      field_type_substitutions = {'text_area'       => 'textarea',
                                  'datetime_select' => 'datetime',
                                  'check_box'       => 'checkbox'}
      field_type = attrib.field_type.to_s.sub(/_field$/,'')
      unless attrib.name.eql?('id')
        self.send((field_type_substitutions[field_type] || field_type), attrib.name.to_sym)
      else
        hidden(:id)
      end
    end


    protected
      def resource_name_for_path
        "admin_#{resource_name}".to_sym
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
        "ExpressCms::#{resource_name.classify}"
      end

  end
end
