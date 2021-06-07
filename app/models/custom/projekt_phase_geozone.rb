class ProjektPhaseGeozone < ApplicationRecord
  belongs_to :projekt_phase, inverse_of: :geozones
  belongs_to :geozone, inverse_of: :projekt_phases
end
