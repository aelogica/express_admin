module ExpressAdmin
  class FlashMessageComponent < ExpressTemplates::Components::Base

    helper(:safe_message) {|message| message[1] }
    helper(:classes) {|message| "flash nav-alert alert-box " }

    emits -> {
      div {
        div(class: ExpressAdmin::FlashMessageComponent.classes('{{flash_message}}'), data: {alert: ''}) {
          safe_message('{{flash_message}}')
          a.close(:href => "#") { "&times;" }
        }
      }
    }

    for_each -> { flash }, as: :flash_message

  end
end
