class ProjektEvent < ApplicationRecord
  belongs_to :projekt

  validates :title, presence: true

  def self.base_selection(scoped_projekt_ids = Projekt.ids)
    where(projekt_id: scoped_projekt_ids)
  end
end
