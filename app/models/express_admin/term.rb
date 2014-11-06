module ExpressAdmin
  class Term < ActiveRecord::Base
    has_one :taxonomy, dependent: :destroy
  end
end
