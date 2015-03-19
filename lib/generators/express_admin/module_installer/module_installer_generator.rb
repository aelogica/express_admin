module ExpressAdmin
  module Generators
    class ModuleInstallerGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)
      attr_reader :project_name, :project_class

      def create_common_files
        @project_name = destination_root.split('/').last

        template "assets/javascripts/ajax_forms.js", File.join('app/assets/javascripts', @project_name, 'admin' ,'ajax_forms.js')
      end

      def create_installer
        @project_class = @project_name.classify

        template 'install/installer.rb.erb', File.join('lib/generators', @project_name, 'install', 'install_generator.rb')
        template 'install/USAGE', File.join('lib/generators', @project_name, 'install', 'USAGE')
        empty_directory File.join('lib/generators', @project_name, 'install', 'templates')
        template 'install/installer_test.rb.erb', File.join('test/lib/generators', @project_name, 'install', 'install_generator_test.rb')
      end
    end
  end
end
