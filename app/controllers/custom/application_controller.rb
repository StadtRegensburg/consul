require_dependency Rails.root.join("app", "controllers", "application_controller").to_s


class ApplicationController < ActionController::Base

  before_action :set_active_and_archived_projekts

  private

  def all_selected_tags
    if params[:tags]
      params[:tags].split(",").map { |tag_name| Tag.find_by(name: tag_name) }.compact || []
    else
      []
    end
  end

  def set_active_and_archived_projekts
    @active_projekts = Projekt.top_level_active.joins(:projekt_settings).where("projekt_settings.key = 'projekt_feature.show_in_navigation' AND projekt_settings.value = 'active'").distinct
    @archived_projekts = Projekt.top_level_archived
  end
end
