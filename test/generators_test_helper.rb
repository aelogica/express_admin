TMP_ROOT = Pathname.new(File.expand_path('tmp'))

module Rails
  def self.tmp_root
    @root ||= TMP_ROOT
  end
end

module GeneratorsTestHelper
  def self.included(base)
    base.class_eval do
      destination TMP_ROOT
      setup :prepare_destination
    end
  end


  def set_rails_root
    Rails.instance_eval do
      alias :old_root :root
      alias :root :tmp_root
    end
  end

  def unset_rails_root
    Rails.instance_eval do
      alias :root :old_root
    end
  end

  def within_destination_rails_root
    set_rails_root
    yield
    unset_rails_root
  end

  def copy_routes
    routes = File.expand_path('test/fixtures/routes.rb')
    destination = File.join(destination_root, 'config')
    FileUtils.mkdir_p(destination)
    FileUtils.cp File.expand_path(routes), File.expand_path(destination)
  end

  def copy_engine
    engine = File.expand_path('test/fixtures/engine.rb')
    destination = File.join(destination_root, 'lib/tmp')
    FileUtils.mkdir_p(destination)
    FileUtils.cp File.expand_path(engine), File.expand_path(destination)
  end

end