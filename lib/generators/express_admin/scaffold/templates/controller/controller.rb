<% module_namespacing do -%>
module Admin
  class <%= controller_class_name %>Controller < AdminController
    respond_to :html

    actions :all, :except => [:edit]

    defaults resource_class: <%= model_class_name %>

    def create
      create! { admin_<%= plural_table_name %>_path }
    end

    def edit
      edit! { admin_<%= plural_table_name %>_path }
    end

    private

      def <%= singular_table_name %>_params
        params.require(:<%= singular_table_name %>).permit!
      end
  end
end
<% end -%>
