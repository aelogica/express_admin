module ExpressAdmin
  class CommandButtonList < ExpressTemplates::Components::Configurable
    include ExpressTemplates::Components::Capabilities::Resourceful

    tag :ul

    has_argument :id, "The name of the resource for this command.  Eg. 'person' for like_person_path()", as: :resource_name, type: :symbol
    # has_option :exclude, "Exclude some buttons"
    # has_option :only, "only some buttons"

    contains -> {
      commands.each do |command|
        li {
          command_button(command, disabled: available?(command))
        }
      end
    }

    def resource_name
      config[:resource_name]
    end

    def available?(command)
      resource.available_commands.include?(command)
    end

    def commands
      resource.commands
    end

  end
end