require_dependency Rails.root.join("app", "models", "map_location").to_s
class MapLocation < ApplicationRecord
  belongs_to :projekt, touch: true

  def json_data
    {
      investment_id: investment_id,
      proposal_id: proposal_id,
      projekt_id: projekt_id,
      lat: latitude,
      long: longitude,
      color: get_pin_color,
      fa_icon_class: get_fa_icon_class
    }
  end

  private

  def get_pin_color(proposal_id)
    if proposal_id.present?
      proposal = Proposal.find_by(id: proposal_id)
      proposal.projekt&.map_location&.pin_color
    elsif projekt_id.present?
      projekt = Projekt.find_by(id: projekt_id)
      projekt.color
    end
  end

  def get_fa_icon_class
    if projekt_id.present?
      projekt = Projekt.find_by(id: projekt_id)
      projekt.icon
    end
  end
end
