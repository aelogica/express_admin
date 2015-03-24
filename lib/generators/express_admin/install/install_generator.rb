module ExpressAdmin
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)
      attr_reader :project_name, :project_class

      def create_common_files
        @project_name = destination_root.split('/').last

        template "assets/javascripts/ajax_forms.js",
          File.join('app/assets/javascripts', @project_name, 'admin' ,'ajax_forms.js')
      end

      def create_installer
        @project_class = @project_name.camelize

        template 'install/installer.rb.erb',
          File.join('lib/generators', @project_name, 'install', 'install_generator.rb')
        template 'install/USAGE', File.join('lib/generators', @project_name, 'install', 'USAGE')
        empty_directory File.join('lib/generators', @project_name, 'install', 'templates')
        template 'install/installer_test.rb.erb',
          File.join('test/lib/generators', @project_name, 'install', 'install_generator_test.rb')
      end

      def create_admin_controller
        template 'controllers/admin_controller.rb.erb',
          File.join('app/controllers', @project_name, 'admin', 'admin_controller.rb')
      end

      def create_admin_layout
        template 'views/layouts/admin.html.et',
          File.join('app/views/layouts', @project_name, 'admin.html.et')
      end

      def create_application_js
        empty_directory("app/assets/javascripts/#{@project_name}/admin")
        template 'assets/javascripts/application.js',
          File.join('app/assets/javascripts', @project_name, 'admin', 'application.js')
      end

      def create_application_css
        empty_directory("app/assets/stylesheets/#{@project_name}/admin")
        template 'assets/stylesheets/application.css',
          File.join('app/assets/stylesheets', @project_name, 'admin', 'application.css')
      end

      def insert_mount_point
        @project_class = @project_name.camelize

        if open(engine_path).any?
          inject_into_file engine_path,
            "    #{@project_class}::Engine.config.#{@project_name}_mount_point = '/'\n",
            after: "class Engine < ::Rails::Engine\n"
        end
      end

      def require_express_admin
        @project_class = @project_name.camelize

        if open(engine_path).any?
          inject_into_file engine_path, "require 'express_admin'\n",
            before: "module #{@project_class}"
        end
      end

      def require_responders
        if open(engine_path).any?
          inject_into_file engine_path, "require 'responders'\n\n",
            after: "require \'express_admin\'\n"
        end
      end

      def create_menu
        template 'config/menu.yml.erb', File.join('config/menu.yml')
      end

      def add_express_admin_menu
        if open(engine_path).any?
          inject_into_file engine_path, "    include ::ExpressAdmin::Menu::Loader\n",
            after: "class Engine < ::Rails::Engine\n"
        end
      end

      def add_responders_to_gemspec
        gemspec_path = Rails.root ? "#{Rails.root}/#{@project_name}.gemspec" : "#{@project_name}.gemspec"

        if open(gemspec_path).any?
          inject_into_file gemspec_path, "s.add_dependency \"responders\", \"~> 2.0\"\n  ",
            before: /s.add_dependency \"rails\"*/
        end
      end

      def precompile_assets
        assets = <<-'EOD'
    initializer :assets do |config|
      engine_assets_path = File.join(File.dirname(__FILE__), '..', '..', 'app', 'assets')
      all_assets = Dir.glob File.join(engine_assets_path, 'stylesheets', '**', '*.css*')
      all_assets += Dir.glob File.join(engine_assets_path, 'javascripts', '**', '*.js*')
      all_assets.each {|path| path.gsub!("#{engine_assets_path}/stylesheets/", '')}
      all_assets.each {|path| path.gsub!("#{engine_assets_path}/javascripts/", '')}
      Rails.application.config.assets.precompile += all_assets
    end
EOD
        if open(engine_path).any?
          inject_into_file engine_path, assets, after: "class Engine < ::Rails::Engine\n"
        end
      end

      private

        def engine_path
          Rails.root ? "#{Rails.root}/lib/#{@project_name}/engine.rb" : "lib/#{@project_name}/engine.rb"
        end
    end
  end
end
