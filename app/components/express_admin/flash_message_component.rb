module ExpressAdmin
  class FlashMessageComponent < ExpressTemplates::Components::Base

    emits :markup, -> {
      div(class: -> {"flash nav-alert alert-box #{flash_class(name)}"}, data: {alert: ''}) {
        message.html_safe
        a.close(:href => "#") { "&times;" }
      }
    }

    using_logic { |markup_code|
      unless flash.empty?
        flash.map do |name, message|
          eval(markup_code)
        end.join
      end
    }

  end
end