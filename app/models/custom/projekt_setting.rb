class ProjektSetting < ApplicationRecord
  belongs_to :projekt

  validates :key, presence: true, uniqueness: { scope: :projekt_id }

  default_scope { order(id: :asc) }

  def prefix
    key.split(".").first
  end

  def type
    if %w[projekt_feature projekt_newsfeed].include? prefix
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
        "projekt_feature.show_comments_in_projekt_footer": nil,
        "projekt_feature.show_notifications_in_projekt_footer": nil,
        "projekt_feature.show_milestones_in_projekt_footer": nil,
        "projekt_feature.show_newsfeed_in_projekt_footer": nil,
        "projekt_newsfeed.id": nil,
        "projekt_newsfeed.type": nil
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
