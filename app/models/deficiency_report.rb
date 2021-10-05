class DeficiencyReport < ApplicationRecord

  include Taggable
  translates :title, touch: true
  translates :description, touch: true
  include Globalizable

  has_one :map_location
  belongs_to :author, -> { with_hidden }, class_name: "User", inverse_of: :deficiency_reports

  validates :terms_of_service, acceptance: { allow_nil: false }, on: :create
  validates :author, presence: true

  scope :sort_by_created_at,       -> { reorder(created_at: :desc) } 

  enum status: {
    incoming: 0,
    pending: 5,
    resolved: 9
  }
end
