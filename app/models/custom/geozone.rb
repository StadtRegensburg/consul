require_dependency Rails.root.join("app", "models", "geozone").to_s

class Geozone < ApplicationRecord
  has_and_belongs_to_many :projekts
end
