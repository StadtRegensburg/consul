class DeficiencyReport::Category < ApplicationRecord
  AVAILABLE_ICONS = [['road'], ['biking'], ['traffic-light']]
  translates :name, touch: true
  include Globalizable
end
