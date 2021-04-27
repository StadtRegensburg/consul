class ProjektPhase < ApplicationRecord
  belongs_to :projekt
  has_many :projekt_phase_geozones, dependent: :destroy
  has_many :geozones, through: :projekt_phase_geozones
end
