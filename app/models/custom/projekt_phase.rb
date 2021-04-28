class ProjektPhase < ApplicationRecord
  belongs_to :projekt
  has_many :projekt_phase_geozones, dependent: :destroy
  has_many :geozones, through: :projekt_phase_geozones

  def selectable_by?(user)
    user.present? &&
      user.level_two_or_three_verified? &&
      (!geozone_restricted || geozone_ids.include?(user.geozone_id))
  end
end
