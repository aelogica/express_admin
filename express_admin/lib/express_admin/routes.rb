module ExpressAdmin
  class Routes
    def self.register(&block)
      registered_route_blocks << block
    end

    def self.registered_route_blocks
      @blocks ||= []
    end

    def self.draw(application_routes)
      registered_route_blocks.each do |route_block|
        application_routes.instance_eval(&route_block)
      end
    end
  end
end