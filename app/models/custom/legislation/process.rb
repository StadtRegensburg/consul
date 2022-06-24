require_dependency Rails.root.join("app", "models", "legislation", "process").to_s

class Legislation::Process < ApplicationRecord
  belongs_to :projekt

  scope :active, -> { all }

  def calculate_tsvector
  end

  def status
  end
end
