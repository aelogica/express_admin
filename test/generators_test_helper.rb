module Rails
  class << self
    remove_possible_method :root
    def root
      @root ||= Pathname.new(File.expand_path('tmp'))
    end
  end
end

module GeneratorsTestHelper
  def self.included(base)
    base.class_eval do
      destination Rails.root
      setup :prepare_destination
    end
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