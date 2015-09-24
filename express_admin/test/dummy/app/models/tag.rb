class Tag < ActiveRecord::Base
  has_many :widget_tags, inverse_of: :tags
  has_many :widgets, through: :widget_tags
end
