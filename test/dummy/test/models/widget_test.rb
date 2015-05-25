require "test_helper"

class WidgetTest < ActiveSupport::TestCase

  def widget
    @widget ||= Widget.new
  end

  def test_valid
    assert widget.valid?
  end

end
