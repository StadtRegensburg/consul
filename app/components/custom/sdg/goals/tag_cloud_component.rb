require_dependency Rails.root.join("app", "components", "sdg", "goals", "tag_cloud_component").to_s

class SDG::Goals::TagCloudComponent < ApplicationComponent

  private
    def target_options
      if params[:sdg_goals]
        selected_goals = params[:sdg_goals].split(',').map{ |sdg| sdg.to_i }
        options_from_collection_for_select(SDG::Target.includes(:goal).where(sdg_goals: { code: selected_goals } ).order(:code), :code, :code)
      else
        options_from_collection_for_select(SDG::Target.includes(:goal).order('sdg_goals.code'), :code, :code)
      end
    end
end
