require 'test_helper'
require 'ostruct'
class CountrySelectTest < ActiveSupport::TestCase

  def resource_assigns
    {example_engine: ExampleEngine::MockRouteProxy.new}
  end

  def helpers
    view = mock_action_view
    class << view
      def widgets_path
        "/widgets"
      end
      alias collection_path widgets_path
    end
    view
  end

  test "country_select renders without an error" do
    assert arbre(widget: Widget.new) {
      express_form(:widget) {
        country_select :column6
      }
    }
  end

  test "can change label for country_select" do
    html = arbre(widget: Widget.new) {
      express_form(:widget) {
        country_select :column6, label: "Country"
      }
    }
    assert_match(/<label.*Country<\/label>/, html)
  end
end
