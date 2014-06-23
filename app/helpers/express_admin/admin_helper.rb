module ExpressAdmin
  module AdminHelper

    def title_partial
      (ExpressAdmin::Engine.config.title_partial rescue nil) || 'layouts/express_admin/title'
    end
  end
end
