class DeficiencyReport::Status < ApplicationRecord
  AVAILABLE_ICONS = [['hourglass-start'], ['hourglass-half'], ['hourglass-end']]
  translates :title, touch: true
  translates :description, touch: true
  include Globalizable
end
