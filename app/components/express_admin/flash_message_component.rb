module ExpressAdmin
  class FlashMessageComponent < ExpressTemplates::Components::Base

    helper(:safe_message) {|message| message[1] }

    emits -> {
      div {
        div(class: '{{flash_classes_for(message)}}', data: {alert: ''}) {
          safe_message('{{message}}')
          a.close(:href => "#") { "&times;" }
        }
      }
    }

    for_each -> { flash }, as: :message

  end
end
