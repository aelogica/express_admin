module ExpressAdmin
  class Commandable
    def initialize(defaults = {})
      @defaults = defaults
    end

    def call(mapper, options = {})
      options = @defaults.merge(options)
      modules = []

      # this is a big hack to reconstruct the module path for the
      # controller from the scope context.  I wish rails provided
      # a nice way to get in there and do this but I do not see it
      # yet... probably because rails does not instantiate require
      # controllers to exist for the route map to be constructed
      controller_name = mapper.send(:parent_resource).controller
      scope = mapper.instance_variable_get(:@scope)

      while scope.respond_to?(:parent) && scope = scope.parent
        possible_module = scope.instance_variable_get(:@hash)[:module]
        break if possible_module.nil?
        modules << possible_module
      end
      modules.compact!
      modules << controller_name

      controller_class = "#{modules.join("/").classify.pluralize}Controller".constantize
      if controller_class.respond_to?(:resource_class)
        resource_class = controller_class.resource_class
        if resource_class.respond_to?(:commands)
          resource_class.commands.each do |action|
            # post :foo, to: "module/controller#foo"
            mapper.member do
              mapper.post action.debang, to: "#{controller_name}##{action.debang}"
            end
          end
        end
      end
    end

  end
end

module ActionDispatch::Routing::Mapper::Resources
  def resources_with_commandable(*resources, &block)
    unless @concerns[:commandable]
      concern :commandable, ExpressAdmin::Commandable.new
    end

    resources_without_commandable(*resources) do |resource|
      block.call(resource) unless block.nil?
      concerns :commandable
    end
  end

  alias :resources_without_commandable :resources
  alias :resources :resources_with_commandable

end