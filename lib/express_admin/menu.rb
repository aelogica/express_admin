module ExpressAdmin
  # Provide menus for Express Admin addon engines.
  #
  # To use:
  #
  # 1) include ExpressAdmin::Menu::Loader in your engine.rb
  # 2) add a config/menu.yml defining the menu structure
  #
  # Example:
  #
  #     title: 'Blog'
  #     path: 'express_blog.admin_blog_posts_path'
  #     items:
  #       -
  #         title: 'Posts'
  #         path: 'express_blog.admin_blog_posts_path'
  #       -
  #         title: 'Categories'
  #         path: 'express_blog.admin_blog_categories_path'
  module Menu

    # Return the top level MenuItem for the addon or defined in the supplied path.
    #
    # Accepts an addon_name such as :express_admin or a path to a yaml file
    # containing a menu definition.
    def self.[](addon_name)
      @menus ||= {}
      @menus[addon_name.to_sym] ||= begin
        addon_path = Gem.loaded_specs[addon_name].full_gem_path if addon_name.to_s.match(/^\w+$/)
        menu_yml_path = File.join(addon_path, 'config', 'menu.yml')
        from(menu_yml_path)
      end
    end

    def self.from(yaml_path)
      raise "unable to locate #{yaml_path}" unless File.exists?(yaml_path)
      MenuItem.new YAML.load_file(yaml_path).with_indifferent_access
    end


    class MenuItem
      attr :title, :path, :position, :items
      def initialize(hash)
        @title = hash[:title]
        @path = hash[:path]
        @position = hash[:position] || 99
        @items = (hash[:items]||[]).map {|item| MenuItem.new(item)}
      end
    end

    module Loader
      def self.included(base)
        class << base
          def addon_name
            self.to_s.split('::')[-2].underscore.to_sym
          end
        end
      end
    end

  end
end
