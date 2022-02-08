class Sidebar::ProjektsFilterComponent < ApplicationComponent
  delegate :projekt_filter_resources_name, to: :helpers

  def initialize(top_level_active_projekts, top_level_archived_projekts, all_resources, current_projekt_footer_tab = nil)
    @top_level_active_projekts = top_level_active_projekts
    @top_level_archived_projekts = top_level_archived_projekts
    @all_resources = all_resources
    @current_projekt_footer_tab = current_projekt_footer_tab
  end

	private

  def show_archived_projekts_in_sidebar?
    true
	end

  def resources_name
    projekt_filter_resources_name
	end
end
