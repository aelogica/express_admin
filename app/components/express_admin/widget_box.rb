module ExpressAdmin
  class WidgetBox < ExpressTemplates::Components::Column
    emits -> {
      div._widget_box._form_container {
        h2._widget_header my[:id].to_s.titleize
        div._widget_body {
          _yield
        }
      }
    }
  end
end
