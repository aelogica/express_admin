module ExpressAdmin
  module StandardActions

    def self.included(base)
      base.class_eval do
        extend ClassMethods
        include InstanceMethods
        helper_method :collection
        helper_method :resource

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
          namespace_route_proxy.send("#{resource_name}_path", resource)
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
          self.instance_variable_set(collection_ivar, resource_class.all)
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
      end

  end
end