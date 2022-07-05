class ProjektManagement::BaseController < ApplicationController
  layout "admin"

  before_action :authenticate_user!
  before_action :verify_projekt_manager

  skip_authorization_check

  private

    def verify_projekt_manager
      raise CanCan::AccessDenied unless current_user&.projekt_manager? || current_user&.administrator?
    end
end
