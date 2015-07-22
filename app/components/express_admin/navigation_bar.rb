module ExpressAdmin
	class NavigationBar < ExpressTemplates::Components::Base

		emits -> {

			nav(class: 'top-bar') {
			  div(class: 'main-menu') {
			    ul(class: 'menu-items') {
			      li {
			        a(href: '#') {
			          image_tag 'express_admin/appexpress_logo_dark.png', class: 'nav-logo'
			        }
			      }
			      mega_menu_component
			      li {
			        icon_link(icon_name: 'android-open', text: 'View Site', href: '/', target: '_blank')
			      }
			      render(partial: 'shared/nav_bar_actions')
			      li { flash_message_component } unless helpers.flash.empty?
			    }
			  }
			  div(class: 'secondary-menu') {
			    ul(class: 'menu-items') {
			      li {
			        a {
			          current_user_gravatar
			          span {'Profile' }
			        }
			        sign_in_or_sign_out
			      }
			    }
			  }
			}
		}

	end
end