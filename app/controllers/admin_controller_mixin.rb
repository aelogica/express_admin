module ExpressAdmin
  module AdminControllerMixin
    def self.included(base)
      base.class_eval do
        include InstanceMethods

        inherit_resources  # Use inherited_resources

        helper ::ExpressAdmin::AdminHelper
        
        before_filter :authenticate_user! if defined?(Devise)
        before_filter :load_collection, only: [:show]
        before_filter :build_new_resource, only: [:index]
      end
    end

    module InstanceMethods

      def show
        show! do |format|
          format.html { render :index }
        end
      end

      private

        def load_collection
          collection # from InheritedResources
        end

        def build_new_resource
          @resource_params = {}
          build_resource
        end
    end
  end
end