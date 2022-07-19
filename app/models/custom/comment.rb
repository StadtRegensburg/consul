require_dependency Rails.root.join("app", "models", "comment").to_s

class Comment < ApplicationRecord
  scope :seen, -> { where.not(ignored_flag_at: nil) }
  scope :unseen, -> { where(ignored_flag_at: nil) }

  scope :joins_projekts, -> {
    joins(
      "INNER JOIN projekts ON comments.commentable_id = projekts.id AND comments.commentable_type = 'Projekt'"
    )
  }
end
