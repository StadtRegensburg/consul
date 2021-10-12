class DeficiencyReport < ApplicationRecord

  include Taggable
  include Mappable
  include Imageable
  include Documentable
  translates :title, touch: true
  translates :description, touch: true
  translates :summary, touch: true
  include Globalizable

  has_one :map_location
  belongs_to :category, class_name: "DeficiencyReport::Category", foreign_key: :deficiency_report_category_id
  belongs_to :status, class_name: "DeficiencyReport::Status", foreign_key: :deficiency_report_status_id
  belongs_to :author, -> { with_hidden }, class_name: "User", inverse_of: :deficiency_reports

  validates :terms_of_service, acceptance: { allow_nil: false }, on: :create
  validates :author, presence: true

  scope :sort_by_created_at,       -> { reorder(created_at: :desc) } 

  def to_param
    "#{id}-#{title}".parameterize
  end
end
