class Sidebar::ProjektsFilterComponent < ApplicationComponent
  delegate :projekt_filter_resources_name, to: :helpers

  def initialize(top_level_active_projekts, top_level_archived_projekts, all_resources, current_projekt_footer_tab = nil, current_projekt = nil)
    @top_level_active_projekts = top_level_active_projekts
    @top_level_archived_projekts = top_level_archived_projekts
    @all_resources = all_resources
    @current_projekt_footer_tab = current_projekt_footer_tab
    @current_projekt = current_projekt
  end

	private

  def show_archived_projekts_in_sidebar?
    true
	end

  def resources_name
    projekt_filter_resources_name
	end

  def resource_name_js
    if @current_projekt_footer_tab && @current_projekt
      "footer#{@current_projekt.id}#{controller_name.capitalize}"
    else
      controller_name
    end
  end

  def form_path
    if @current_projekt_footer_tab && @current_projekt
      send("#{@current_projekt_footer_tab}_footer_tab_page_path")
    else
      send("#{controller_name}_path")
    end
  end

  def local_form?
    controller_name == 'pages' ? false : true
  end
end
