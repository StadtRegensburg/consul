class ProjektManager < ApplicationRecord
  belongs_to :user, touch: true
  delegate :name, :email, :name_and_email, to: :user

  has_many :projekts

  validates :user_id, presence: true, uniqueness: true
end
