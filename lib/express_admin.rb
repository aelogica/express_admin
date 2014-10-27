require "express_admin/menu"
require "express_admin/engine"
require "express_templates"

# should be a way to add this folder to rails' autoload paths
components = Dir.glob(File.join(File.dirname(__FILE__), '..', 'app', 'components', '**', '*.rb'))
components.each {|component| require component }

module ExpressAdmin
end
