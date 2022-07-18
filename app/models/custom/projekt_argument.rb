class ProjektArgument < ApplicationRecord
  include Imageable

  belongs_to :projekt

  validates :name, presence: true
  validates :party, presence: true
  validates :pro, presence: true
  validates :position, presence: true
  validates :note, presence: true

  default_scope { order(created_at: :asc) }

  scope :sort_by_all, -> {
    all
  }

  scope :sort_by_pro, -> {
    where(pro: true)
  }

  scope :sort_by_cons, -> {
    where(pro: false)
  }
end
