class Admin::BaseController < ApplicationController
  layout "admin"
  before_action :authenticate_user!

  skip_authorization_check unless: :projekt_manager_action?
  before_action :verify_administrator, unless: :projekt_manager_action?

  private

    def verify_administrator
      raise CanCan::AccessDenied unless current_user&.administrator?
    end

    def projekt_manager_action?
      raise CanCan::AccessDenied unless current_user&.projekt_manager? || current_user&.administrator?

      params[:namespace] == "projekt_management" ||
        params[:controller].split("/").first == "projekt_management" ||
        params[:controller] == "admin/projekts/map_layers"
    end
end
