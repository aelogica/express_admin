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
