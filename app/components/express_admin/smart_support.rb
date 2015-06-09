module ExpressAdmin
  module SmartSupport
    def namespace
      @config[:namespace] || infer_namespace
    end

    def path_prefix
      @config[:path_prefix] || infer_path_prefix
    end

    def resource_class
      if @config[:class_name]
        return @config[:class_name]
      else
        class_name = ["#{resource_name.classify}"]
        class_name.unshift("#{namespace.classify}") unless namespace.nil?
        class_name.join("::")
      end
    end

    private

      def infer_namespace
        expander = @args.last
        if expander.respond_to?(:template)
          path_parts = expander.template.virtual_path.split('/')

          case
          when path_parts.size == 4
            path_parts.first
          when path_parts.size == 3
            mod = path_parts.first.classify.constantize
            if mod.const_defined?(:Engine)
              path_parts.first
            else
              nil
            end
          else
            nil
          end
        else
          nil
        end
      end

      def infer_path_prefix
        expander = @args.last
        if expander.respond_to?(:template)
          path_parts = expander.template.virtual_path.split('/')

          case
          when path_parts.size == 4
            path_parts[1]
          when path_parts.size == 3
            mod = path_parts.first.classify.constantize
            if mod.const_defined?(:Engine)
              nil
            else
              path_parts.first
            end
          else
            nil
          end
        else
          nil
        end
      end

      # TODO: this can now be inferred from the template.virtual_path
      # if not supplied...
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
          "#{namespace}.#{collection_name_with_prefix}_path"
        else
          "#{collection_name_with_prefix}_path"
        end
      end

      def collection_name_with_prefix
        if path_prefix
          "#{path_prefix}_#{collection_name}"
        else
          collection_name
        end
      end

      def resource_path(ivar=false)
        if @config[:resource_path]
          @config[:resource_path]
        else
          full_path_helper = namespace ?
            "#{namespace.underscore}.#{resource_name_with_path_prefix}_path" :
            "#{resource_name_with_path_prefix}_path"

          "#{full_path_helper}(#{ivar ? '@' : ''}#{resource_name}.id)"
        end
      end

      def resource_name_with_path_prefix
        if path_prefix
          "#{path_prefix}_#{resource_name}"
        else
          resource_name
        end
      end

      def resource_klass
        resource_class.constantize
      end

      def columns
        resource_class.constantize.columns
      end


  end
end