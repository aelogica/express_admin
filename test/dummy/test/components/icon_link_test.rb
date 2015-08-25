require 'test_helper'

module ExpressAdmin

  class IconLinkTest < ActiveSupport::TestCase

    def assigns
      {resource: resource}
    end

    def resource
      @resource ||= OpenStruct.new(
      text: 'Beer',
      title: 'beer icon',
      target: '_blank',
      right: true,
      delete: true,
      confirm: true,
      href: 'http://something.com'
      )
    end

    def helpers
      mock_action_view
    end

    def rendered_icon_link(*args)
      arbre {
       icon_link(:beer, *args)
      }.to_s
    end

    test "renders" do
      assert rendered_icon_link
    end

    test "icon link href default is set to #" do
      assert_match /href="#"/, rendered_icon_link
    end

    test "icon-link target set to blank" do
      # binding.pry
      assert_match /target="_blank"/, rendered_icon_link(target: "#{resource[:target]}")
    end

    test "delete attribute is true" do
      assert_match /data-delete="true"/, rendered_icon_link(delete: resource[:delete])
    end

    test "confirm attribute is true" do
      assert_match /data-confirm="true"/, rendered_icon_link(confirm: resource[:confirm])
    end

    test "icon link has title set" do
      assert_match /title="beer icon"/, rendered_icon_link(title: "#{resource[:title]}")
    end

    test "icon link has accompanying text" do
      assert_match /i>\nBeer<\/a>/, rendered_icon_link(text: "#{resource[:text]}")
    end

    test "icon link has link set" do
      assert_match /href="#{resource[:href]}"/, rendered_icon_link(href: "#{resource[:href]}")
    end

    MARKUP_RIGHT = <<-HTML
<a class="icon-link" href="#">
Beer  <i class="icon ion-beer"></i>
</a>
HTML

    test "if icon-link is set to right" do
      assert_equal MARKUP_RIGHT, rendered_icon_link(text: "#{resource[:text]}", right: "#{resource[:right]}")
    end

  end
end
