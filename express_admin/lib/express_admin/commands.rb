module ExpressAdmin
  module Commands
    def self.included(base)
      base.class_eval do
        include InstanceMethods
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

    module InstanceMethods
      # If not using, AASM, override this for disallowing commands
      def unavailable_commands
        []
      end

      def available_commands
        if respond_to?(:aasm)
          commands & aasm_event_triggers
        else
          commands - unavailable_commands
        end
      end

      protected
        def aasm_event_triggers
          aasm.events.map(&:name).map(&:to_s).map {|s| "#{s}!"}.map(&:to_sym)
        end
    end
  end
end

ActiveRecord::Base.include(ExpressAdmin::Commands)

class Symbol
  def debang
    to_s.gsub(/\!\Z/, '').to_sym
  end
end