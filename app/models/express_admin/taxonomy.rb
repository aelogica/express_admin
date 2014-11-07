module ExpressAdmin
  class Taxonomy < ActiveRecord::Base
    belongs_to :term
    belongs_to :parent_term, class_name: 'Term', foreign_key: 'parent_term_id'
    has_many :object_taxonomies

    self.inheritance_column = :_type_disabled

    scope :list, -> { includes(:term).order('express_admin_terms.name') }

    ExpressAdmin::Taxonomy.pluck(:taxonomy).uniq.each do |taxonomy|
      scope taxonomy.pluralize.to_sym, -> { where(taxonomy: taxonomy) }
    end
  end
end
