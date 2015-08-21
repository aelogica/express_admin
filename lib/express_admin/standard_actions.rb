module ExpressAdmin
  module StandardActions

    def self.included(base)
      base.class_eval do
        extend ClassMethods
        include InstanceMethods
        helper_method :collection
        helper_method :resource
        helper_method :resource_path
        helper_method :collection_path

        class_attribute :defaults
        self.defaults = {layout: 'layouts/express_admin/admin'}

        before_filter :expose_parent_resources
      end
    end

    module ClassMethods
      def inherited(base)
        base.class_eval <<-RUBY
          def #{base.resource_name}_params
            params.require(:#{base.resource_name}).permit!
          end
        RUBY
      end

      def resource_name
        self.to_s.demodulize.gsub(/Controller$/, '').singularize.underscore
      end
    end

    module InstanceMethods
      def index
        build_resource
        load_collection
        respond_to do |format|
          format.html { render :index, layout: defaults[:layout] }
        end
      end

      def new
        build_resource
        respond_to do |format|
          format.html { render :new, layout: defaults[:layout] }
        end
      end

      def create
        build_resource(resource_params)
        if resource.save
          respond_to do |format|
            format.html { redirect_to resource_path }
          end
        else
          respond_to do |format|
            format.html { render :new, layout: defaults[:layout] }
          end
        end
      end

      def show
        load_resource
        load_collection
        respond_to do |format|
          format.html { render :show, layout: defaults[:layout] }
        end
      end

      def edit
        load_resource
        respond_to do |format|
          format.html { render :edit, layout: defaults[:layout] }
        end
      end

      def update
        load_resource
        if resource.update_attributes(resource_params)
          respond_to do |format|
            format.html { redirect_to resource_path }
          end
        else
          respond_to do |format|
            format.html { render :edit, layout: defaults[:layout] }
          end
        end
      end

      def destroy
        load_resource
        resource.destroy!
        respond_to do |format|
          format.html { redirect_to :index }
        end
      end

      protected
        def resource_path
          proxy = route_proxy
          proxy ||= self
          if parent_resource_names.blank?
            proxy.send(scoped_path_helper("#{resource_name}_path"), resource)
          else
            proxy.send(scoped_path_helper(nested_resource_path_helper), resource_ids_hash)
          end
        end

        def scoped_path_helper(path_helper)
          [scope_name, path_helper].compact.join('_')
        end

        def collection_path
          proxy = route_proxy
          proxy ||= self
          if parent_resource_names.blank?
            proxy.send(scoped_path_helper("#{collection_name}_path"))
          else
            proxy.send(scoped_path_helper(nested_collection_path_helper), resource_ids_hash)
          end
        end

        def parent_module_name
          self.class.to_s.match(/(\w+)::/).try(:[], 1)
        end

        def route_proxy
          engine = "#{parent_module_name}::Engine".constantize rescue nil
          if parent_module_name && engine
            self.send(parent_module_name.underscore)
          else
            nil
          end
        end

        def scope_name
          engine = "#{parent_module_name}::Engine".constantize rescue nil
          if parent_module_name && engine.nil?
            return parent_module_name.underscore
          else
            nil
          end
        end

        def resource_params
          self.send("#{resource_name}_params")
        end

        def nested?
          !parent_resource_names.empty?
        end

        def parent_resource
          self.send("current_#{parent_resource_names.last}")
        end

        def end_of_association_chain
          if nested?
            parent_resource.send(resource_name.pluralize)
          else
            resource_class
          end
        end

        def load_collection
          self.instance_variable_set(collection_ivar, end_of_association_chain.all)
        end

        def collection_ivar
          "@#{collection_name}".to_sym
        end

        def collection
          self.instance_variable_get(collection_ivar)
        end

        def collection_name
          self.class.to_s.demodulize.gsub(/Controller$/, '').pluralize.underscore
        end

        def resource
          self.instance_variable_get(resource_ivar)
        end

        def build_resource(*args)
          if nested?
            self.instance_variable_set(resource_ivar, end_of_association_chain.build(*args))
          else
            self.instance_variable_set(resource_ivar, resource_class.new(*args))
          end
        end

        def load_resource
          self.instance_variable_set(resource_ivar, resource_class.find(params[:id]))
        end

        def resource_ivar
          "@#{resource_name}".to_sym
        end

        def resource_class
          self.class.to_s.gsub(/Controller$/, '').singularize.classify.constantize
        end

        # Foo::WidgetsController ->  widget
        def resource_name
          self.class.resource_name
        end

        def nested_resource_path_helper
          (parent_resource_names + [resource_name, 'path']).join('_')
        end

        def nested_collection_path_helper
          (parent_resource_names + [collection_name, 'path']).join('_')
        end

        def expose_parent_resources
          parent_resources = parent_resource_names
          return if parent_resources.blank?
          previous_parent = nil
          parent_resources.each do |parent_name|
            # TODO: optimize
            parent_id = extract_path_info_from_routes["#{parent_name}_id".to_sym]
            current_parent = "current_#{parent_name}".to_sym
            unless self.methods.include?(current_parent)
              if previous_parent.nil?
                self.class_eval do
                  define_method(current_parent) do
                    parent_class = parent_module_name.constantize
                    current_class_name = parent_name.camelize
                    current_class = parent_class.const_defined?(current_class_name) ?
                      parent_class.const_get(current_class_name) :
                      "::#{parent_name.camelize}".constantize
                    current_class.find(parent_id)
                  end
                end
              else
                self.class_eval do
                  grandparent_accessor = previous_parent
                  define_method(current_parent) do
                    grandparent_resource = self.send(grandparent_accessor)
                    parent_scope = grandparent_resource.send(parent_name.pluralize)
                    parent_scope.find(parent_id)
                  end
                end
              end
            end
            previous_parent = current_parent
          end
        end

        def parent_resource_names
          path_info = extract_path_info_from_routes
          unless path_info.nil?
            path_info.keys.grep(/_id$/).map do |id|
              id.to_s.gsub(/_id$/, '')
            end
          end
        end

        def extract_path_info_from_routes
          recognized_path = nil
          Rails::Engine.subclasses.each do |engine|
            engine_instance = engine.instance
            engine_route = Rails.application.routes.routes.find do |r|
              r.app.app == engine_instance.class
            end
            next unless engine_route
            path_for_engine = request.path.gsub(%r(^#{engine_route.path.spec.to_s}), "")
            begin
              recognized_path = engine_instance.routes.recognize_path(path_for_engine)
            rescue ActionController::RoutingError => e
            end
          end
          if recognized_path.nil?
            begin
              recognized_path = Rails.application.routes.recognize_path(request.path)
            rescue ActionController::RoutingError => e
            end
          end
          recognized_path
        end

        def resource_ids_hash
          parent_resource_names.inject({id: resource.to_param}) do |hash, name|
            hash["#{name}_id".to_sym] = self.send("current_#{name}".to_sym).to_param
            hash
          end
        end

    end
  end
end
