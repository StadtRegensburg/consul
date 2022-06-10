class Users::SessionsController < Devise::SessionsController
  def destroy
    logger.tagged('sessions#destroy') { logger.info "stored_location_for(:user): #{stored_location_for(:user)}" } 
    @stored_location = stored_location_for(:user)
    super
  end

  private

    def after_sign_in_path_for(resource)
      if !verifying_via_email? && resource.show_welcome_screen?
        logger.tagged('after_sign_in_path_for') { logger.info "Welcome path: #{welcome_path}" } 
        welcome_path
      else
        logger.tagged('after_sign_in_path_for') { logger.info "Super path: #{super}" } 
        super
      end
    end

    def after_sign_out_path_for(resource)
      logger.tagged('after_sign_out_path_for') { logger.info "@stored_location: #{@stored_location}" } 
      logger.tagged('after_sign_out_path_for') { logger.info "Super: #{super}" } 
      @stored_location.present? && !@stored_location.match("management") ? @stored_location : super
    end

    def verifying_via_email?
      return false if resource.blank?

      stored_path = session[stored_location_key_for(resource)] || ""
      stored_path[0..5] == "/email"
    end
end
