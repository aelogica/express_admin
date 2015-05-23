require 'rails/generators/rails/scaffold/scaffold_generator'

module ExpressAdmin
  module Generators
    class ScaffoldGenerator < ::Rails::Generators::ScaffoldGenerator
      source_root File.expand_path("../templates", __FILE__)
      attr_reader :view_path, :resource_class

      remove_hook_for :scaffold_controller

      def create_root_folder
        empty_directory admin_view_path
      end

      def copy_view_files
        available_views.each do |view|
          template "#{view}.html.et.erb", File.join(admin_view_path, "#{view}.html.et")
        end
      end

      def generate_controller
        controller_file_path = File.join(["app/controllers", project_name, admin_controller_path, "#{controller_file_name}_controller.rb"].compact)
        template "controller/controller.rb", controller_file_path
      end

      def add_route
        route_path = Rails.root ? "#{Rails.root}/config/routes.rb": "config/routes.rb"
        if open(route_path).grep("scope '#{project_path}'").any?
          inject_into_file 'config/routes.rb', "        resources :#{controller_file_name}\n",
            after: "scope '#{project_path}' do\n"
        else
          if module_name
            admin_route = <<-EOD
  namespace :admin do
    scope '#{module_name}' do
      resources :#{controller_file_name}, except: [:edit]
    end
  end
EOD
          else
            admin_route = <<-EOD
  namespace :admin do
    resources :#{controller_file_name}, except: [:edit]
  end
EOD
          end
          inject_into_file 'config/routes.rb', admin_route,
            after: "#{namespaced?}::Engine.routes.draw do\n"
        end
      end

      def add_menu_item
menu_entry = %Q(
  -
    title: '#{controller_file_name.titleize}'
    path: '#{namespaced?.to_s.underscore}.#{project_name}_admin_#{controller_file_name}_path'
)
        menu_path = Rails.root ? "#{Rails.root}/config/menu.yml": "config/menu.yml"
        if File.exists?(menu_path)
          inject_into_file menu_path, menu_entry, after: 'items:'
        end
      end


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

        def project_path
          project_name || Rails.application.class.parent_name
        end

        def project_name
          namespaced_path rescue nil
        end

        def module_name
          controller_class_path.last if controller_class_path.size.eql?(2)
        end

        def admin_controller_path
          # place the generated controller into an Admin module
          acp = controller_class_path.dup
          if acp.empty?
            acp.push 'admin'
          else
            acp.insert(1,'admin').compact.slice(1..-1)
          end
          File.join acp
        end

        def model_class_name
          class_path_parts = class_name.split("::")
          class_path_parts.unshift namespace.to_s if namespaced?
          class_path_parts.join("::")
        end

        def admin_view_path
          path_parts = ["app/views", project_name, admin_controller_path, controller_file_name]
          File.join path_parts.compact
        end

        def model_path
          if Rails.application
            class_name.underscore
          else
            # drop the module name for the engine as the generators
            # we invoke will automatically add it back again
            class_name.split("::").slice(1..-1).join("::").underscore
          end
        end

      private

        def destroy(what, *args)
          log :destroy, what
          argument = args.flat_map(&:to_s).join(" ")
          # in_root { run_ruby_script("bin/rails destroy #{what} #{argument}", verbose: true) }
          system("bin/rails destroy #{what} #{argument}")
        end



    end
  end
end
