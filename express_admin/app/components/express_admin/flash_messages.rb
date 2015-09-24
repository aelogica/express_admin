module ExpressAdmin
  class FlashMessages < ExpressTemplates::Components::Base

    contains -> {
      helpers.flash.each do |flash_message|
        div(class:"flash nav-alert alert-box #{flash_message[0]}", data: {alert: ''}) {
          span flash_message[1]
          a(class: 'close', href: "#") { "&times;".html_safe }
        }
      end

      content_for(:page_javascript) {
        script {
          %Q(
            window.addEventListener("load", function() {
              $(function() {
                $('a.close').on('click', function(e){
                  e.preventDefault()
                  $(this).parents('.flash-messages').remove()
                })
              })
            });
          ).html_safe
        }
      }
    }

  end
end
