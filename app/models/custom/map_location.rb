require_dependency Rails.root.join("app", "models", "map_location").to_s
class MapLocation < ApplicationRecord
  belongs_to :projekt, touch: true
  belongs_to :deficiency_report, touch: true

  def json_data
    {
      investment_id: investment_id,
      proposal_id: proposal_id,
      projekt_id: projekt_id,
      deficiency_report_id: deficiency_report_id,
      lat: latitude,
      long: longitude,
      color: get_pin_color,
      fa_icon_class: get_fa_icon_class
    }
  end

  private

  def get_pin_color
    if proposal_id.present?
      proposal = Proposal.find_by(id: proposal_id)
      proposal.projekt&.map_location&.pin_color
    elsif deficiency_report_id.present?
      deficiency_report = DeficiencyReport.find_by(id: deficiency_report_id)
      deficiency_report.category&.color
    end
  end

  def get_fa_icon_class
    if deficiency_report_id.present?
      deficiency_report = DeficiencyReport.find_by(id: deficiency_report_id)
      deficiency_report.category&.icon
    end
  end
end
