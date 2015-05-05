module ExpressAdmin
  class SmartForm < ExpressTemplates::Components::Base


# <% for attribute in attributes -%>

#            f.actions({
#              cancel: ['Cancel', {class: 'button radius tiny secondary cancel hide', href: '{{admin_blog_posts_path}}'}],
#              submit: ['Save', class: 'button tiny right radius ajax-submit', remote: true]
#            }, wrapper_class: 'form-group widget-buttons')


    emits -> {
      null_wrap {
        "smart form goes here"
      }
    }
  end
end
