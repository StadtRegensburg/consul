require_dependency Rails.root.join("app", "models", "legislation", "process").to_s

class Legislation::Process < ApplicationRecord
  scope :active, -> { all }

  def calculate_tsvector
  end

  def status
  end
end
