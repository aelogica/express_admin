require 'rails/generators/erb/scaffold/scaffold_generator'

module ExpressAdmin
  module Generators
    class ScaffoldGenerator < Erb::Generators::ScaffoldGenerator
      source_root File.expand_path("../templates", __FILE__)
      attr_reader :project_name, :project_path, :view_path, :resource_class

      def create_root_folder
        @project_name = if Rails.application
                          Rails.application.class.parent_name
                        else
                          class_path.first.classify
                        end
        @project_path = @project_name.underscore
        @resource_class = "#{@project_name}::#{singular_name.camelize}".classify
        @view_path = File.join('app/views', @project_path, 'admin', plural_name)
        empty_directory File.join("app/views", @project_path, "admin", controller_file_path)
      end

      def copy_view_files
        available_views.each do |view|
          filename = filename_with_extensions(view)
          template "#{view}.html.et.erb", File.join("app/views", @project_path, "admin", controller_file_path, filename)
        end
      end

      def create_controller_file
        template "controller/controller.rb", File.join("app/controllers", @project_path, "admin", "#{controller_file_path}_controller.rb")
      end

      def create_model_file
        template "model/model.rb", File.join("app/models/", @project_path, "#{singular_name}.rb")
      end

      def create_datatables_files
        template "datatables/datatables.rb", File.join('app/datatables', @project_path, "#{singular_name}_datatable.rb")
        template "datatables/datatables.js", File.join('app/assets/javascripts', @project_path, 'admin' ,"#{controller_file_name}.js")
      end

      def add_route
        if open('config/routes.rb').grep(/scope '#{@project_path}', as: '#{@project_path}'/).any?
          inject_into_file 'config/routes.rb', "          resources :#{controller_file_name}\n",
            after: /scope '#{@project_path}', as: '#{@project_path}' do\n/
        else
          append_to_file 'config/routes.rb', <<-EOD
\n\n
if Kernel.const_defined?('ExpressAdmin::Engine')
  ExpressAdmin::Engine.routes.draw do
    scope ExpressAdmin::Engine.config.admin_mount_point do
      scope module: 'admin', as: 'admin' do
        scope '#{@project_path}', as: '#{@project_path}' do
          resources :#{controller_file_name}
        end
      end
    end
  end
end
EOD
        end
      end

      def create_migration
        args = ''
        attributes.each do |attribute|
          args << "#{attribute.name}:#{attribute.type} "
        end

        generate :migration, "create_#{plural_table_name} #{args}"
      end

      hook_for :form_builder, :as => :scaffold

      protected
        def available_views
          %w(index)
        end

        def available_actions
          %w(index show update destroy)
        end

        def handler
          :et
        end
    end
  end
end
