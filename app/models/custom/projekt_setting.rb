class ProjektSetting < ApplicationRecord
  belongs_to :projekt

  validates :key, presence: true, uniqueness: { scope: :projekt_id }

  default_scope { order(id: :asc) }

  class << self

    def defaults
      {
        "projekt.connected_resources": nil,
        "projekt.projekt_page_sharing": nil,
        "projekt.show_archived.navigation": true,
        "projekt.show_archived.sidebar": true,
        "projekt.show_phases_in_projekt_page_sidebar": true,
        "projekt.show_total_duration_in_projekts_page_sidebar": true,
        "projekt.show_not_active_phases_in_projekts_page_sidebar": true,
        "projekt.show_navigator_in_projekts_page_sidebar": true,
        "projekt.show_module_links_in_flyout_menu": true,
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
