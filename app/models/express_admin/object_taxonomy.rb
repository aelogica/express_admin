module ExpressAdmin
  class ObjectTaxonomy < ActiveRecord::Base
    belongs_to :klassifiable, polymorphic: true
    belongs_to :taxonomy
  end
end
