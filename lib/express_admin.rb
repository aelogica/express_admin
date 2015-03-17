require "express_admin/menu"
require "express_admin/engine"
require "express_templates"

# should be a way to add this folder to rails' autoload paths
components = Dir.glob(File.join(File.dirname(__FILE__), '..', 'app', 'components', '**', '*.rb'))
components.each {|component| require component }

module ExpressAdmin
  mattr_accessor :module_name
  class Railtie < ::Rails::Railtie
    config.app_generators.template_engine :et
  end
end
