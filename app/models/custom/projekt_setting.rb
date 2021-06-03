class ProjektSetting < ApplicationRecord
  belongs_to :projekt

  validates :key, presence: true, uniqueness: { scope: :projekt_id }

  default_scope { order(id: :asc) }

  def prefix
    key.split(".").first
  end

  def type
    if %w[projekt_feature projekt_map].include? prefix
      prefix
    else
      "configuration"
    end
  end

  class << self

    def defaults
      {
        "projekt_feature.show_in_navigation": nil,
        "projekt_feature.show_projekt_footer": nil,
        "projekt_feature.show_activity_and_map_in_projekt_footer": true,
        "projekt_feature.show_comments_in_projekt_footer": true,
        "projekt_feature.show_notifications_in_projekt_footer": true,
        "projekt_feature.show_milestones_in_projekt_footer": true,
        "projekt_feature.show_newsfeed_in_projekt_footer": true,
        "projekt_map.latitude": '51.372637664637566',
        "projekt_map.longitude": '-0.06454467773437501',
        "projekt_map.zoom": 10
      }
    end

    def ensure_existence
      Projekt.all.each do |projekt|

        defaults.each do |name, value|
          unless find_by(key: name, projekt_id: projekt.id)
            self.create(key: name, value: value, projekt_id: projekt.id)
          end
        end

      end
    end

  end

  def enabled?
    value.present?
  end

end
