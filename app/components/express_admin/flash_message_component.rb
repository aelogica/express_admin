module ExpressAdmin
  class FlashMessageComponent < ExpressTemplates::Components::Base

    emits {
      div(class: -> {"flash nav-alert alert-box #{flash_class(name)}"}, data: {alert: ''}) {
        safe_message
        a.close(:href => "#") { "&times;" }
      }
    }

    using_logic { |markup_code|
      # unless flash.empty?
        flash.map do |name, message|
          safe_message = message.html_safe
          eval(markup_code)
        end.join
      # end
    }

  end
end