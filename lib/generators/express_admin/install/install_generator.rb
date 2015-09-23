module ExpressAdmin
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)
      attr_reader :project_name, :project_class

      def create_common_files
        @project_name = destination_root.split('/').last
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

      def create_admin_layout
        template 'views/layouts/admin.html.et',
          File.join('app/views/layouts', @project_name, 'admin.html.et')
      end

      def create_custom_devise_login
        if defined?(Devise)
          template 'views/devise/sessions/new.html.et', 
            File.join('app/views/devise/sessions/new.html.et')
        end
      end

      def create_application_js
        template 'assets/javascripts/application.js',
          File.join('app/assets/javascripts', @project_name, 'admin.js')
      end

      def create_application_css
        template 'assets/stylesheets/application.css',
          File.join('app/assets/stylesheets', @project_name, 'admin.css')
      end

      def insert_mount_point
        @project_class = @project_name.camelize

        if File.exists?(engine_path)
          inject_into_file engine_path,
            "    #{@project_class}::Engine.config.#{@project_name}_mount_point = '/'\n",
            after: "class Engine < ::Rails::Engine\n"
        end

        empty_directory File.join('config', 'initializers')
        if File.exists?(engine_path)
          create_file File.join('config', 'initializers', "mount_engine.rb"),
            "ExpressAdmin::Routes.register do |routes|\n  routes.mount #{@project_class}::Engine, at: #{@project_class}::Engine.config.#{@project_name}_mount_point\nend\n"
        end
      end

      def require_express_admin
        @project_class = @project_name.camelize

        if File.exists?(engine_path)
          inject_into_file engine_path, "require 'express_admin'\n",
            before: "module #{@project_class}"
        end
      end

      def create_menu
        template 'config/menu.yml.erb', File.join('config/menu.yml')
      end

      def add_express_admin_menu
        if File.exists?(engine_path)
          inject_into_file engine_path, "    include ::ExpressAdmin::Menu::Loader\n",
            after: "class Engine < ::Rails::Engine\n"
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
        if File.exists?(engine_path)
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
