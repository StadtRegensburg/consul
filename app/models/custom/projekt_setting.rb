class ProjektSetting < ApplicationRecord
  belongs_to :projekt

  validates :key, presence: true, uniqueness: { scope: :projekt_id }

  default_scope { order(id: :asc) }

  class << self

    def defaults
      {
        "projekt.show_in_navigation": nil,
        "projekt.show_projekt_footer": nil,
        "projekt.show_activity_and_map_in_projekt_footer": true,
        "projekt.show_comments_in_projekt_footer": true,
        "projekt.show_notifications_in_projekt_footer": true,
        "projekt.show_milestones_in_projekt_footer": true,
        "projekt.show_newsfeed_in_projekt_footer": true
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
