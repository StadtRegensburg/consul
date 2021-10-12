class DeficiencyReport::Category < ApplicationRecord
  translates :name, touch: true
  include Globalizable
end
