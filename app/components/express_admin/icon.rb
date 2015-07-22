module ExpressAdmin
  class Icon < ExpressTemplates::Components::Configurable

    tag :i

    has_argument :id, "The name of the ionic icon withouth the ion- prefix. See http://ionicons.com/cheatsheet.html",
                 as: :name

    before_build {
      add_class("ion-#{config[:name]}")
    }
  end
end