class Widget < ActiveRecord::Base
  belongs_to :category

  has_many :widget_tags, inverse_of: :widget
  has_many :tags, through: :widget_tags

end
