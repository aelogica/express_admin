module ExpressAdmin
  class FlashMessageComponent < ExpressTemplates::Components::Base

    emits -> {
      helpers.flash.each do |flash_message|
        div(class:"flash nav-alert alert-box ", data: {alert: ''}) {
          span flash_message[1]
          a(class: 'close', href: "#") { "&times;".html_safe }
        }
      end
    }
  end
end
