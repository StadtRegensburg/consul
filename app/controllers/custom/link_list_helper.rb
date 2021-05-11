require_dependency Rails.root.join("app", "helpers", "link_list_helper").to_s

module LinkListHelper
  def link_list_sdg_goals(*links, **options)
    return "" if links.select(&:present?).empty?

    tag.ul(options) do
      safe_join(links.select(&:present?).map do |text, url, current = false, **link_options|
        selected_goal_codes = params[:sdg_goals].present? ? params[:sdg_goals].split(',').map{ |code| code.to_i } : []
        goal_code = link_options[:data].present? ? link_options[:data][:code] : nil
        active_class = (selected_goal_codes.blank? || selected_goal_codes.include?(goal_code)) ? 'selected-goal' : 'unselected-goal'
        current_class = params[:sdg_goals].present? 
        tag.li(class: "js-sdg-custom-goal-filter #{active_class}") do
					link_to text, '#', link_options
        end
      end, "\n")
    end
  end
end
