class DeficiencyReport < ApplicationRecord

  translates :title, touch: true
  translates :description, touch: true
  include Globalizable

  enum status: {
    incoming: 0,
    pending: 5,
    resolved: 9
  }
end
