class DeficiencyReport::Category < ApplicationRecord
  AVAILABLE_ICONS = [['road'], ['biking'], ['traffic-light']]
  translates :name, touch: true
  include Globalizable

  has_many :deficiency_reports, foreign_key: :deficiency_report_category_id

  def safe_to_destroy?
    !deficiency_reports.exists?
  end
end
