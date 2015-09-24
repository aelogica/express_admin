module ExpressAdmin
  module ModuleSettingsHelper
    def edit_setting(param)
      setting = setting_for(param)
      domkey = param.gsub(/\W/, '_')

      name = "settings[#{param}]"
      title = param.titlecase
      value = params[param.to_sym].nil? ? setting.value : params[param.to_sym]
      html = ""

      if setting.boolean?
        html << content_tag(:div, class: 'form-group') do
          hidden_field_tag(name, '0') +
          check_box_tag(name, true, value, class: 'setting', id: domkey) +
          content_tag(:label, title, class: 'checkbox', for: domkey)
        end

      elsif setting.selector?
        html << content_tag(:div, class: 'form-group') do
          content_tag(:label, title, for: domkey) +
          select_tag(name, options_for_select(setting.definition.selection, value), class: 'setting', id: domkey)
        end

      else
        html << content_tag(:div, class: 'form-group') do
          content_tag(:label, title, for: domkey) +
          text_field_tag(name, value, class: 'textbox', id: domkey)
        end

      end

      if setting.errors.messages[:value]
        html << content_tag(:span, [setting.errors.messages[:value]].flatten.first, class: 'error')
        html = content_tag(:span, html, class: "error-with-field")
      end

      html.html_safe

    end

    def setting_for(setting)
      @editable_setting ||= {}
      @editable_setting[setting] ||= ExpressAdmin.module_name.constantize.settings.find_or_create_by(setting: setting)
    end

    def definition_for(setting)
      if setting = setting_for(setting)
        setting.definition
      end
    end
  end
end
