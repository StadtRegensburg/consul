class DeficiencyReport::Status < ApplicationRecord
  translates :title, touch: true
  translates :description, touch: true
  include Globalizable
end
