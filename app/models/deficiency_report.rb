class DeficiencyReport < ApplicationRecord

  include Taggable
  include Mappable
  include Imageable
  include Documentable
  translates :title, touch: true
  translates :description, touch: true
  translates :summary, touch: true
  translates :official_answer, touch: true
  include Globalizable

  acts_as_votable
  acts_as_paranoid column: :hidden_at
  include ActsAsParanoidAliases

  belongs_to :category, class_name: "DeficiencyReport::Category", foreign_key: :deficiency_report_category_id
  belongs_to :status, class_name: "DeficiencyReport::Status", foreign_key: :deficiency_report_status_id
  belongs_to :officer, class_name: "DeficiencyReport::Officer", foreign_key: :deficiency_report_officer_id
  belongs_to :author, -> { with_hidden }, class_name: "User", inverse_of: :deficiency_reports
  has_many :comments, as: :commentable, inverse_of: :commentable, dependent: :destroy

  validates :terms_of_service, acceptance: { allow_nil: false }, on: :create
  validates :author, presence: true

  scope :sort_by_newest,       -> { reorder(created_at: :desc) }

  def to_param
    "#{id}-#{title}".parameterize
  end

  def code
    "CONSUL-DF-#{created_at.strftime("%Y-%m")}-#{id}"
  end

  def can_be_published?
    if Setting['deficiency_reports.admins_must_approved_officer_answer'].present?
      official_answer.present? && official_answer_approved?
    else
      official_answer.present?
    end
  end

  def shall_be_approved?
    Setting['deficiency_reports.admins_must_approved_officer_answer'].present? &&
      !official_answer_approved?
  end

  def total_votes
    cached_votes_total
  end

  def likes
    cached_votes_up
  end

  def dislikes
    cached_votes_down
	end

  def votes_score
    cached_votes_score
  end

  def votable_by?(user)
    user.present? ? true : false
  end

  def register_vote(user, vote_value)
    if votable_by?(user)
      vote_by(voter: user, vote: vote_value)
    end
  end

end
