require 'express_admin/standard_actions'

module ExpressAdmin
  class StandardController < ::ApplicationController

    include StandardActions

    def initialize(*args)
      raise "StandardController must be subclassed" if self.class.eql?(StandardController)
    end

  end
end