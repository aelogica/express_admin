require "test_helper"

class WidgetTagTest < ActiveSupport::TestCase

  def widget_tag
    @widget_tag ||= WidgetTag.new
  end

  def test_valid
    assert widget_tag.valid?
  end

end
