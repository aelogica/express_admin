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
          if parent_resource_names.blank?
            namespace_route_proxy.send("#{resource_name}_path", resource)
          else
            namespace_route_proxy.send(nested_path, resource_ids_hash)
          end
        end

        def collection_path
          namespace_route_proxy.send("#{nested_path}#{collection_name}_path")
        end

        def namespace_route_proxy
          if parent_namespace = self.class.to_s.match(/(\w+)::/).try(:[], 1)
            self.send(parent_namespace.underscore)
          else
            self
          end
        end

        def resource_params
          self.send("#{resource_name}_params")
        end

        def load_collection
          if parent_resource_names.blank?
            self.instance_variable_set(collection_ivar, resource_class.all)
          else
            # TODO: handle nested resources here
            self.instance_variable_set(collection_ivar, resource_class.all)
          end
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
          self.instance_variable_set(resource_ivar, resource_class.new(*args))
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

        def nested_path
          (parent_resource_names + [resource_name, 'path']).join('_')
        end

        def expose_parent_resources
          parent_resources = parent_resource_names
          return if parent_resources.blank?
          previous_parent = nil
          parent_resources.each do |parent_name|
            # TODO: optimize
            parent_id = extract_path_info_from_routes["#{parent_name}_id".to_sym]
            current_parent = "current_#{parent_name}".to_sym
            unless self.respond_to?(current_parent)
              if previous_parent.nil?
                self.class_eval do
                  define_method(current_parent) do
                    "::#{parent_name.capitalize}".constantize.find(parent_id)
                  end
                end
              else
                self.class_eval do
                  define_method(current_parent) do
                    self.send(previous_parent).send(
                      parent_name.pluralize).find(parent_id)
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
              recognized_path = engine_instance.routes.recognize_path(path_for_engine, method: request.method)
            rescue ActionController::RoutingError => e
            end
          end
          if recognized_path.nil?
            begin
              recognized_path = Rails.application.routes.recognize_path(request.path, method: request.method)
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
