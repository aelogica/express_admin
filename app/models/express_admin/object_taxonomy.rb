module ExpressAdmin
  class ObjectTaxonomy < ActiveRecord::Base
    belongs_to :objectable, polymorphic: true
    belongs_to :taxonomy
  end
end
