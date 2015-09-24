module ExpressAdmin
  class NavBarActions < ExpressTemplates::Components::Base
    tag :li

    contains -> {
      render(partial: 'shared/nav_bar_actions') rescue nil
    }
  end
end
