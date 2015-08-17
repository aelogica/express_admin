require 'rails/generators/generated_attribute'

module ExpressAdmin
  class SmartForm < ExpressTemplates::Components::Forms::ExpressForm
    TIMESTAMPS = %w(updated_at created_at)

    has_option :virtual, 'Override the list of virtual attributes of the resource to be displayed', type: :array,
      values: -> (*) { resource_class.respond_to?(:virtual_attributes) ? resource_class.virtual_attributes : [] }
    has_option :exclude, 'Attributes not to be included in the form', type: :array
    has_option :only, 'Respects the order the attributes are listed in', type: :array
    has_option :show_timestamps, 'Set to true to show timestamps as labels'

    contains {
      # TODO: taken from express_form. should be inherited?
      div(style: 'display:none') {
        add_child helpers.utf8_enforcer_tag
        add_child helpers.send(:method_tag, resource.persisted? ? :put : :post)
        helpers.send(:token_tag)
      }

      filter_by_name(editable_attributes).each do |attrib|
        form_field_for(attrib)
      end
      filter_by_name(has_many_through_associations).each do |assoc|
        select_collection(assoc.name, nil, nil, class: 'select2')
      end
      if show_timestamps?
        filter_by_name(timestamp_attributes).each do |timestamp|
          div {
            label {
              "#{timestamp.name.titleize}: #{resource.try(timestamp.name.to_sym)}"
            }
          }
        end
      end
      submit(class: 'button')
    }


    def form_field_for(attrib)
      field_type_substitutions = {'text_area'       => 'textarea',
                                  'datetime_select' => 'datetime',
                                  'check_box'       => 'checkbox'}
      field_type = attrib.field_type.to_s.sub(/_field$/,'')
      field_type = "password" if attrib.name.match(/password/)
      if relation = attrib.name.match(/(\w+)_id$/).try(:[], 1)
          # TODO: should allow select2 override
          select(attrib.name.to_sym, options: config["#{relation}_collection".to_sym], select2: true)
      else
        if field_type == 'text_area'
          if attrib.name == 'definition'
            # TODO allow other fields aside from layout.definition
            base_styles = "position: relative; height: 300px;"
            target = [attributes[:class].to_a.last, attrib.name].join("_")
            textarea attrib.name.to_sym, rows: 10, class: "hide", hidden: true
            content_tag(:div, '', id: "ace_#{attrib.name}", class: "ace-input", style: base_styles, data: { target: target })
          else
            textarea attrib.name.to_sym, rows: 10
          end
        else
          self.send((field_type_substitutions[field_type] || field_type), attrib.name.to_sym)
        end
      end
    end

    protected

      def resource_attributes
        super.map do |attrib|
          field_definition = [attrib.name, attrib.type] # index not important here for now
          Rails::Generators::GeneratedAttribute.parse(field_definition.join(":"))
        end
      end

      def editable_attributes
        non_timestamp_attributes + virtual_attributes
      end

      def virtual_attributes
        (config[:virtual]||[]).map do |attrib_name|
          Rails::Generators::GeneratedAttribute.parse("#{attrib_name}:string")
        end
      end

      def excluded_attributes
        excl = [:id]
        excl += config[:exclude] if config[:exclude]
        excl
      end

      def timestamp_attributes
        resource_attributes.select {|attrib| TIMESTAMPS.include?(attrib.name) }
      end

      def show_timestamps?
        !!config[:show_timestamps]
      end

      def non_timestamp_attributes
        resource_attributes.reject {|attrib| TIMESTAMPS.include?(attrib.name) }
      end

      def has_many_through_associations
        resource_class.reflect_on_all_associations(:has_many).select do |assoc|
          assoc.options.keys.include?(:through)
        end
      end

      def filter_by_name(attribs)
        if config[:only]
          # if using :only, we respect the order
          config[:only].map do |only|
            attribs.detect {|attrib| only.to_s.eql?(attrib.name)} || nil
          end.compact
        else
          attribs
        end.reject {|attrib| (excluded_attributes).map(&:to_s).include? attrib.name }
      end

  end
end
