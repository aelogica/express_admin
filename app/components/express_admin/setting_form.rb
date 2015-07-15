module ExpressAdmin
  class SettingForm < ExpressTemplates::Components::Configurable

    # .widget-box
    #   %h2.widget-header Blog
    #   .widget-body
    #     = form_tag admin_blog_settings_path, id: 'blog-setting-form', onSubmit: 'return false;', method: 'patch' do
    #       = hidden_field_tag :form_id, 'blog-setting-form'
    #       - ExpressBlog.settings.blog_setting.each do |setting|
    #         = edit_setting setting
    #       .form-group.widget-buttons
    #         = submit_tag 'Save', class: 'button tiny right radius ajax-submit'


    def save_button
      submit_tag 'Save', class: 'button tiny right radius ajax-submit'
    end

    def settings_path
      helpers.instance_eval("admin_#{current_module_path_name.gsub(/express_/, '')}_settings_path")
    end

    def settings(setting_type)
      current_module.settings.send("#{setting_type}_setting").map do |setting|
        edit_setting(setting)
      end.join()
    end

    emits -> (block) {
      widget_box(config[:id]) {
        setting_selector = config[:id].to_s.gsub('_', '-')
        form(href: ExpressAdmin::SettingForm.settings_path, id: "#{setting_selector}-setting-form", onSubmit: 'return false;', method: 'POST') {
          form_rails_support(:patch)
          hidden_field_tag :form_id, "#{setting_selector}-setting-form"
          div(class: 'form-group') {
            block.call(self) if block
          }
          settings(config[:id])
          div(class: "form-group widget-buttons") {
            save_button
          }
        }
      }
    }


  end
end
