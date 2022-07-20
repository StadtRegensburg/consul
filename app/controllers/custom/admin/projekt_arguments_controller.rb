class Admin::ProjektArgumentsController < Admin::BaseController
  include ImageAttributes

  before_action :set_projekt, except: :destroy

  def create
    @projekt_argument = ProjektArgument.new(projekt_argument_params)
    @projekt_argument.projekt = @projekt

    if @projekt_argument.save
      redirect_to request_referer, notice: t("admin.settings.flash.updated")
    else
      render request_referer, error: t("admin.settings.flash.error")
    end
  end

  def update
    @projekt_argument = ProjektArgument.find_by(id: params[:id])
    @projekt_argument.update(projekt_argument_params)

    redirect_to request_referer, notice: t("admin.settings.flash.updated")
  end

  def destroy
    @projekt_argument = ProjektArgument.find_by(id: params[:id])
    @projekt_argument.destroy
    redirect_to(request.referer + '#tab-projekt-arguments', notice: t("custom.admin.flash.deleted"))
  end

  private

  def projekt_argument_params
    params.require(:projekt_argument).permit(:name, :party, :pro, :position, :note, image_attributes: image_attributes)
  end

  def set_projekt
    @projekt = Projekt.find(params[:projekt_id])
  end

  def request_referer
    return request.referer + params[:projekt_argument][:tab] if params[:projekt_argument][:tab]

    request.referer
  end
end
