module ExpressAdmin
  module Commands
    def self.included(base)
      base.class_eval do
        extend ClassMethods

        class_attribute :commands
        self.commands = []
      end
    end

    module ClassMethods

      def exposes_command(command)
        exposes_commands command
      end

      def exposes_commands(*commands)
        self.commands += commands
      end
    end
  end
end

ActiveRecord::Base.include(ExpressAdmin::Commands)