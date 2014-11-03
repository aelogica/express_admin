require_dependency "express_admin/application_controller"

module ExpressAdmin
  module Admin
    class SettingsController < ExpressAdmin::Admin::AdminController
      before_filter :authenticate_user!

      def show
        @settings = ExpressAdmin.settings.all
      end

      def update
        respond_to do |format|
          begin
            ExpressAdmin.settings.transaction do
              settings_params.each_pair do |setting, value|
                ExpressAdmin.settings[setting] = value
              end

              format.json {render json: {success: true, form_id: params[:form_id], message: 'Settings saved.'}, response: 200}
            end
          rescue ActiveRecord::RecordInvalid => e
            format.json {render json: {success: false}, response: :unprocessable_entity}
          rescue ExpressAdmin::Settings::SettingsError => e
            format.json {render json: {success: false}, response: :unprocessable_entity}
          end
        end
      end

      private
        def settings_params
          params.require(:settings)
        end
    end
  end
end
