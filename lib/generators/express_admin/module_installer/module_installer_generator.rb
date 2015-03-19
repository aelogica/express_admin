module ExpressAdmin
  module Generators
    class ModuleInstallerGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)
      attr_reader :project_name

      def create_common_files
        @project_name = destination_root.split('/').last

        template "assets/javascripts/ajax_forms.js", File.join('app/assets/javascripts', @project_name, 'admin' ,'ajax_forms.js')
      end

    end
  end
end
