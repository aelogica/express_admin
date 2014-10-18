module ExpressAdmin
  class SettingForm < ExpressTemplates::Components::Container
    include ExpressTemplates::Components::Capabilities::Configurable

    # .widget-box
    #   %h2.widget-header Blog
    #   .widget-body
    #     = form_tag admin_blog_settings_path, id: 'blog-setting-form', onSubmit: 'return false;', method: 'patch' do
    #       = hidden_field_tag :form_id, 'blog-setting-form'
    #       - ExpressBlog.settings.blog_setting.each do |setting|
    #         = edit_setting setting
    #       .form-group.widget-buttons
    #         = submit_tag 'Save', class: 'button tiny right radius ajax-submit'


    helper(:save_button) { submit_tag 'Save', class: 'button tiny right radius ajax-submit' }

    helper(:settings_path) { self.send("admin_#{current_module_path_name.gsub(/express_/, '')}_settings_path") }

    helper(:settings) { |setting_type|
      current_module.settings.send("#{setting_type}_setting").map do |setting|
        edit_setting(setting)
      end.join()
    }

    emits widget_wrapper: -> {
                    widget_box(my[:id]) {
                      setting_selector = my[:id].to_s.gsub('_', '-')
                      form(href: SettingForm.settings_path, id: "#{setting_selector}-setting-form", onSubmit: 'return false;', method: 'patch') {
                        hidden_field_tag :form_id, "#{setting_selector}-setting-form"
                        div._form_group {
                          _yield
                        }
                        settings(my[:id])
                        div._form_group._widget_buttons {
                          save_button
                        }
                      }
                    }
                  }

    wrap_with :widget_wrapper

  end
end
