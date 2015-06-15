require 'rails/generators/generated_attribute'

module ExpressAdmin
  class SmartForm < ExpressTemplates::Components::Base
    include ExpressTemplates::Components::Capabilities::Configurable
    include ExpressTemplates::Components::Capabilities::Resourceful
    include ExpressTemplates::Components::Forms::FormSupport

    emits -> {
      express_form(form_args) {
        hidden(:id)
        editable_attributes.each do |attrib|
          form_field_for(attrib)
        end
        has_many_through_associations.each do |assoc|
          select_collection(assoc.name)
        end
        timestamp_attributes.each do |timestamp|
          div {
            label {
              "#{timestamp.name.titleize}: {{@#{resource_name}.try(:#{timestamp.name})}}"
            }
          }
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
      if attrib.name.match(/_id$/)
        select(attrib.name)
      else
        self.send((field_type_substitutions[field_type] || field_type), attrib.name.to_sym)
      end
    end

    protected

      def form_args
        {           id: resource_name,
                action: form_action,
         resource_name: resource_name,
        resource_class: @config[:resource_class],
             namespace: namespace}
      end

      def attributes
        super.map do |attrib|
          field_definition = [attrib.name, attrib.type] # index not important here for now
          Rails::Generators::GeneratedAttribute.parse(field_definition.join(":"))
        end
      end

      def editable_attributes
        attributes.reject do |attrib|
          TIMESTAMPS.include?(attrib.name) ||
          excluded_attributes.map(&:to_s).include?(attrib.name)
        end + virtual_attributes
      end

      def virtual_attributes
        (@config[:virtual]||[]).map do |attrib_name|
          Rails::Generators::GeneratedAttribute.parse("#{attrib_name}:string")
        end
      end

      def excluded_attributes
        excl = [:id]
        excl += @config[:exclude] if @config[:exclude]
        excl
      end

      def timestamp_attributes
        attributes.select {|attrib| (TIMESTAMPS - (@config[:exclude]||[]).map(&:to_s)).include?(attrib.name) }
      end

      def has_many_through_associations
        resource_class.reflect_on_all_associations(:has_many).select do |assoc|
          assoc.options.keys.include?(:through) && !excluded_attributes.include?(assoc.name.to_sym)
        end
      end

  end
end
