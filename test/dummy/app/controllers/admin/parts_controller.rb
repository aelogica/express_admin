module Admin
  class PartsController < ExpressAdmin::StandardController

    protected

      def resource_class
        ::Part
      end

  end
end
