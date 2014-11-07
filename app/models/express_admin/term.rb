module ExpressAdmin
  class Term < ActiveRecord::Base
    has_many :taxonomies
  end
end
