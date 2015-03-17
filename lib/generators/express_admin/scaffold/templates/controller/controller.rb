module <%= project_name %>
  module Admin
    class <%= @project_name %>::Admin::<%= controller_class_name %>Controller < ExpressAdmin::AdminController
      respond_to :json, :html

      def index
        @<%= singular_table_name %> = <%= @resource_class %>.new
        respond_to do |format|
          format.html
          format.json { render json: <%= singular_table_name.capitalize %>Datatable.new(view_context) }
        end
      end

      def create
        if @<%= singular_table_name %> = <%= @resource_class %>.create(<%= singular_table_name %>_params)
          render json: {<%= singular_table_name %>: @<%= singular_table_name %>, status: :created}
        else
          render json: {status: :unprocessable_entity}
        end
      end

      def show
        @<%= singular_table_name %> = <%= @resource_class %>.find_by_id(params[:id])
        if @<%= singular_table_name %>
          render json: {<%= singular_table_name %>: @<%= singular_table_name %>, status: :ok}
        else
          render json: {status: :not_found}
        end
      end

      def update
        @<%= singular_table_name %> = <%= @resource_class %>.find_by_id(params[:id])
        if @<%= singular_table_name %>.update_attributes(<%= singular_table_name %>_params)
          render json: {status: :ok}
        else
          render json: {status: :unprocessable_entity}
        end
      end

      def destroy
        @<%= singular_table_name %> = <%= @resource_class %>.find_by_id(params[:id])
        if @<%= singular_table_name %>.destroy
          render json: {status: :no_content}
        else
          render json: {status: :unprocessable_entity}
        end
      end

      private

        def <%= singular_table_name %>_params
          params.require(:<%= singular_table_name %>).permit!
        end
    end
  end
end