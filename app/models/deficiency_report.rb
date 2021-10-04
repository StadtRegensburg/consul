class DeficiencyReport < ApplicationRecord

  include Taggable
  translates :title, touch: true
  translates :description, touch: true
  include Globalizable

  has_one :map_location

  validates :terms_of_service, acceptance: { allow_nil: false }, on: :create

  enum status: {
    incoming: 0,
    pending: 5,
    resolved: 9
  }
end
