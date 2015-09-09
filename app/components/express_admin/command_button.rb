module ExpressAdmin
  module Components
    module Navigation
      class CommandButton < ExpressTemplates::Components::Configurable
        include ExpressTemplates::Components::Capabilities::Resourceful


        has_argument :id, "The command name.  Invoked as an action on the resource.", as: :command, type: :symbol
        has_option :disabled, "Disables the button", type: :boolean
        has_option :confirm, "Prompt with the question specified."
        has_option :resource_name, "The name of the resource for this command.  Eg. 'person' for like_person_path()"

        before_build -> {
          config[:command] = config[:command].debang
          add_class(config[:command])
        }

        contains -> {
          button_to config[:command].to_s.titleize, action, button_to_options
        }

        def resource_name
          config[:resource_name] || parent_command_button_list.resource_name
        end

        def button_to_options
          {remote: true, disabled: config[:disabled], confirm: config[:confirm]}
        end

        def action
          helpers.send "#{config[:command]}_#{resource_path_helper}", resource.to_param
        end

        def parent_command_button_list
          @parent_button_list ||= parent
          until @parent_button_list.nil? || @parent_button_list.kind_of?(CommandButtonList)
            @parent_button_list = @parent_button_list.parent
          end
          return @parent_button_list
        end
      end
    end

  end
end