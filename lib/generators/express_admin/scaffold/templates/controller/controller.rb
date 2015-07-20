<% module_namespacing do -%>
class <%= controller_class_name %>Controller < AdminController

  defaults resource_class: <%= model_class_name %>

  private

    def <%= singular_table_name %>_params
      params.require(:<%= singular_table_name %>).permit!
    end
end
<% end -%>
