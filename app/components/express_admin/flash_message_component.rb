module ExpressAdmin
  class FlashMessageComponent < ExpressTemplates::Components::Base
  # - unless flash.empty?
  #   - flash.each do |name, message|
  #     %div
  #       .flash.nav-alert.alert-box{class: flash_class(name), data: {alert: ''}}
  #         = message.html_safe
  #         %a.close{:href => "#"} &times;
    emits {
      div(class: '{{"flash nav-alert alert-box "+flash_class(name)}}', data: {alert: ''}) {
        safe_message
        a.close(:href => "#") { "&times;" }
      }
    }

    using_logic { |c|
      flash.map do |name, message|
        safe_message = message
        eval(c[:markup])
      end.join
    }

  end
end