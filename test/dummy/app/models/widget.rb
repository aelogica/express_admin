class Widget < ActiveRecord::Base
  belongs_to :category

  has_many :widget_tags, inverse_of: :widget
  has_many :tags, through: :widget_tags
  has_many :parts

  attr :password

  exposes_command :twiddle

  def twiddle
    update_attributes(column2: "twiddled")
  end

end
