module ExpressAdmin
  module SmartSupport

    private

      def resource_name
        @config[:id].to_s.singularize
      end

      def collection_member_name
        resource_name
      end

      def collection_name
        collection_member_name.pluralize
      end

      def collection_var
        "@#{collection_name}".to_sym
      end

      def collection_path
        if namespace
          "#{namespace}.#{collection_name}_path"
        else
          "#{collection_name}_path"
        end
      end

      def namespace
        @config[:namespace]
      end

      def resource_path
        if @config[:resource_path]
          @config[:resource_path]
        else
          full_path_helper = namespace ?
            "#{namespace.underscore}.#{resource_name}_path" :
            "#{resource_name}_path"

          "#{full_path_helper}(@#{resource_name}.id)"
        end
      end

      def resource_class
        class_name = ["#{collection_member_name.classify}"]
        class_name.unshift("#{namespace.classify}") unless namespace.nil?
        class_name.join("::")
      end

      def resource_klass
        resource_class.constantize
      end

      def columns
        resource_class.constantize.columns
      end


  end
end