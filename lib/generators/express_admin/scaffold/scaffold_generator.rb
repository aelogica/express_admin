require 'rails/generators/erb/scaffold/scaffold_generator'

module ExpressAdmin
  module Generators
    class ScaffoldGenerator < Erb::Generators::ScaffoldGenerator
      source_root File.expand_path("../templates", __FILE__)
      def copy_view_files
        available_views.each do |view|
          filename = filename_with_extensions(view)
          template "#{view}.html.et.erb", File.join("app/views/", Rails.application.class.parent_name.underscore, "admin", controller_file_path, filename)
        end
      end

      hook_for :form_builder, :as => :scaffold

      protected
        def available_views
          %w(index)
        end

        def handler
          :et
        end
    end
  end
end
