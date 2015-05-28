require 'test_helper'

module ExpressAdmin
  class SmartThing
    include SmartSupport

    attr_accessor :virtual_path

    def initialize(virtual_path, config = {})
      @virtual_path = virtual_path
      @config = config
      @args = [self]
    end

    def template
      self
    end
  end

  class SmartSupportTest < ActiveSupport::TestCase
    test 'infers namespace and path prefix within an engine and scope' do
      smart_thing = SmartThing.new('express_admin/admin/something/index')
      assert_equal 'express_admin', smart_thing.namespace
      assert_equal 'admin', smart_thing.path_prefix
    end

    test 'infers a namespace and no prefix within an engine' do
      # if defined? ExpressFoo::Engine
      smart_thing = SmartThing.new('express_admin/something/index')
      assert_equal 'express_admin', smart_thing.namespace
      assert_equal nil, smart_thing.path_prefix
    end

    test 'no namespace, infers prefix within a scope within an app' do
      # else of case above
      smart_thing = SmartThing.new('admin/something/index')
      assert_equal nil, smart_thing.namespace
      assert_equal 'admin', smart_thing.path_prefix
    end

    test 'no namespace, no prefix within an app' do
      smart_thing = SmartThing.new('somethings/index')
      assert_equal nil, smart_thing.namespace
      assert_equal nil, smart_thing.path_prefix
    end

    test "#resource_class returns class_name option if specified" do
      assert_equal 'FooBar', SmartThing.new('somethings/index', class_name: 'FooBar').resource_class
      assert_equal 'Something', SmartThing.new('somethings/index', id: :something).resource_class
    end
  end
end
