module ExpressAdmin
  class Taxonomy < ActiveRecord::Base
    belongs_to :term
    belongs_to :parent_term, class_name: 'Term', foreign_key: 'parent_term_id'
    has_many :object_taxonomies

    self.inheritance_column = :_type_disabled
  end
end
