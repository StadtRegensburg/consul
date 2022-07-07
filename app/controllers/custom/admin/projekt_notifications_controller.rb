class Admin::ProjektNotificationsController < Admin::BaseController
  before_action :set_projekt

  def create
    @projekt_notification = ProjektNotification.new(projekt_notification_params)
    @projekt_notification.projekt = @projekt
    @projekt_notification.save
    redirect_to redirect_path(@projekt), notice: t("admin.settings.flash.updated")
  end

  def update
    @projekt_notification = ProjektNotification.find_by(id: params[:id])
    @projekt_notification.update(projekt_notification_params)
    redirect_to redirect_path(@projekt), notice: t("admin.settings.flash.updated")
  end

  def destroy
    @projekt_notification = ProjektNotification.find_by(id: params[:id])
    @projekt_notification.destroy
    redirect_to redirect_path(@projekt)
  end

  private

  def projekt_notification_params
    params.require(:projekt_notification).permit(:title, :body)
  end

  def set_projekt
    @projekt = Projekt.find(params[:projekt_id])
  end

  def redirect_path(projekt)
    if params[:role] == 'projekt_manager'
      edit_projekt_management_projekt_path(projekt) + '#tab-projekt-notifications'
    else
      edit_admin_projekt_path(projekt) + '#tab-projekt-notifications'
    end
  end
end
