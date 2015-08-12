module ExpressAdmin
  class NavBarActions < ExpressTemplates::Components::Base
    contains -> {
      render(partial: 'shared/nav_bar_actions') rescue nil
    }
  end
end
