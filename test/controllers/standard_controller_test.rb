require 'test_helper'

module ExpressAdmin

  class StandardControllerTest < ActiveSupport::TestCase

    class WidgetsController < StandardController
      def resource_class
        Widget
      end
      def parent_resource_names
        [] # skip nested resource handling
      end
    end

    def widgets_controller(params = {})
      @widgets_controller ||= WidgetsController.new
      eigenclass = class << @widgets_controller ; self ; end
      eigenclass.send(:define_method, :params) do
        ActionController::Parameters.new(params.with_indifferent_access)
      end
      # hack so we can call the action without all controller stuff
      eigenclass.send(:define_method, :respond_to) do |&block|
        block.call(ActionController::MimeResponds::Collector.new([], 'text/html'))
      end
      @widgets_controller
    end

    test "it should have all the standard actions" do
      [:new, :create, :show, :index, :edit, :update, :destroy].each do |action|
        assert StandardController.instance_methods.include?(action), "StandardController does not implement ##{action}"
      end
    end

    test "should require a subclass for instantiation" do
      assert_raises(RuntimeError) do
        StandardController.new
      end
    end

    def resource
      widgets_controller.instance_variable_get(:@widget)
    end

    def collection
      widgets_controller.instance_variable_get(:@widgets)
    end

    test "#new should expose a new instance of resource" do
      widgets_controller.new
      assert resource, "@widget not provided by #new"
      refute resource.persisted?, "@widget should not be persisted"
    end

    test "#create should expose an instance of resource" do
      widgets_controller(widget: {column2: 'nothing'}).create
      assert resource, "@widget not provided by #create"
      assert resource.persisted?, "@widget not saved"
    end

    test "#show should expose an instance of resource if found" do
      widgets_controller(id: widgets(:one).id).show
      assert resource, "@widget not provided by #show"
      assert resource.persisted?, "@widget not saved"
    end

    test "#index should expose a collection of resources" do
      widgets_controller.index
      assert collection, "@widgets not provided by #index"
      refute collection.empty?, "@widgets is empty"
    end

    test "#edit should expose an instance of resource if found" do
      widgets_controller(id: widgets(:one).id).edit
      assert resource, "@widget not provided by #edit"
      assert resource.persisted?, "@widget not saved"
    end

    test "#update should expose an updated instance of resource if found" do
      widgets_controller(id: widgets(:one).id, widget: {column2: "Updated"}).update
      assert resource, "@widget not provided by #update"
      assert_equal "Updated", resource.column2
      assert resource.persisted?, "@widget not saved"
    end

    test "#destroy destroys" do
      @widget = Widget.create!(column2: 'Destroy Me')
      assert @widget.persisted?
      widgets_controller(id: @widget.id).destroy
      assert_raises(ActiveRecord::RecordNotFound) do
        Widget.find(@widget.id)
      end
    end

    test "it should provide collection and resource helpers" do
      controller = widgets_controller
      controller.index
      assert controller.send(:collection).respond_to?(:count), "collection not provided by #index"
      assert controller.send(:resource), "resource not provided by #index"
    end

    test "it should provide a default strong params" do
      assert_raises(ActionController::ParameterMissing) do
        widgets_controller.create
      end
      widgets_controller(widget: {column2: 'nothing'}).create
    end

    # TODO: Implement later
    # test "for nested resources it should try to expose a current method for parent resources"

    test ".define_command_method defines a command action method on the controller" do
      refute widgets_controller.respond_to?(:foo)
      widgets_controller.class.send(:define_command_method, :foo, :foo!)
      assert widgets_controller.respond_to?(:foo)
    end

    test "if a resource exposes commands, the controllers should have an action for the command" do
      assert widgets_controller.respond_to?(:twiddle), "widgets_controller#twiddle should be there"
      widgets_controller(id: widgets(:one).id).twiddle
      assert widgets(:one).reload.column2.eql?("twiddled"), "widgets_controller#twiddle didn't twiddle the widget"
    end
  end
end
