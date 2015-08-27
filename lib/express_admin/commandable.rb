module ExpressAdmin
  class Commandable
    def initialize(defaults = {})
      @defaults = defaults
    end

    def call(mapper, options = {})
      options = @defaults.merge(options)
      controller_name = mapper.send(:parent_resource).controller
      resource_class = "#{controller_name.classify.pluralize}Controller".constantize.resource_class
      resource_class.commands.each do |action|
        # post :foo, to: "module/controller#foo"
        mapper.member do
          mapper.post action, to: "#{controller_name}##{action}"
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