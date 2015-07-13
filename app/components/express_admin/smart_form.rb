require 'rails/generators/generated_attribute'

module ExpressAdmin
  class SmartForm < ExpressTemplates::Components::Base
    include ExpressTemplates::Components::Capabilities::Configurable
    include ExpressTemplates::Components::Capabilities::Resourceful
    include ExpressTemplates::Components::Forms::FormSupport

    emits -> {
      express_form(form_args) {
        hidden(:id)
        filter_by_name(editable_attributes).each do |attrib|
          form_field_for(attrib)
        end
        filter_by_name(has_many_through_associations).each do |assoc|
          select_collection(assoc.name, nil, nil, class: 'select2')
        end
        filter_by_name(timestamp_attributes).each do |timestamp|
          div {
            label {
              "#{timestamp.name.titleize}: {{@#{resource_name}.try(:#{timestamp.name})}}"
            }
          }
        end
        submit(class: 'button')
      }
    }

    TIMESTAMPS = ['updated_at', 'created_at']

    def form_field_for(attrib)
      field_type_substitutions = {'text_area'       => 'textarea',
                                  'datetime_select' => 'datetime',
                                  'check_box'       => 'checkbox'}
      field_type = attrib.field_type.to_s.sub(/_field$/,'')
      if relation = attrib.name.match(/(\w+)_id$/).try(:[], 1)
        if opts = @config["#{relation}_collection".to_sym]
          select(attrib.name, opts, select2: true)
        else
          select(attrib.name, nil, select2: true)
        end
      else
        if field_type == 'text_area'
          textarea attrib.name.to_sym, rows: 10
        else
          self.send((field_type_substitutions[field_type] || field_type), attrib.name.to_sym)
        end
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
        non_timestamp_attributes + virtual_attributes
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
        attributes.select {|attrib| TIMESTAMPS.include?(attrib.name) }
      end

      def non_timestamp_attributes
        attributes.reject {|attrib| TIMESTAMPS.include?(attrib.name) }
      end

      def has_many_through_associations
        resource_class.reflect_on_all_associations(:has_many).select do |assoc|
          assoc.options.keys.include?(:through)
        end
      end

      def filter_by_name(attribs)
        if @config[:only]
          # if using :only, we respect the order
          @config[:only].map do |only|
            attribs.detect {|attrib| only.to_s.eql?(attrib.name)} || nil
          end.compact
        else
          attribs
        end.reject {|attrib| (excluded_attributes).map(&:to_s).include? attrib.name }
      end

  end
end
