class Admin::ProjektSettingsController < Admin::BaseController
  def update
    @projekt_setting = ProjektSetting.find_by(id: params[:projekt_id])
      # above line is a workaround to avoid editing FeaturedSettingsComponent

    if current_user.projekt_manager?
      authorize! :update, @projekt_setting
    end

    @projekt_setting.update!(projekt_setting_params)

    respond_to do |format|
      format.html { redirect_to request_referer, notice: t("admin.settings.flash.updated") }
      format.js
    end
  end

  private

    def projekt_setting_params
      params.require(:projekt_setting).permit(:value)
    end

    def request_referer
      return request.referer + params[:projekt_setting][:tab] if params[:projekt_setting][:tab]

      request.referer
    end
end
