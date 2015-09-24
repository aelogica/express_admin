class WidgetTag < ActiveRecord::Base
  belongs_to :widget, inverse_of: :widget_tags
  belongs_to :tag
end
