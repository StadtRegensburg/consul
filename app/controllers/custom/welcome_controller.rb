require_dependency Rails.root.join("app", "controllers", "welcome_controller").to_s

class WelcomeController < ApplicationController
  def welcome
    redirect_to root_path
  end

  def index
    @header = Widget::Card.header.first
    @feeds = Widget::Feed.active
    @cards = Widget::Card.body.where(card_category: "")
    @active_projekt_cards = Widget::Card.body.where(card_category: 'active_projekt')
    @archived_projekt_cards = Widget::Card.body.where(card_category: 'archived_projekt')
    @remote_translations = detect_remote_translations(@feeds,
                                                      @recommended_debates,
                                                      @recommended_proposals)

    @latest_polls = Poll.current.order(created_at: :asc).limit(3)


    latest_proposals = Proposal.last_week
    latest_debates = Debate.last_week
    @latest_resources = (latest_proposals.to_a + latest_debates.to_a).sort_by(&:created_at).reverse.first(3)
    set_debate_votes(latest_debates)
    set_proposal_votes(latest_proposals)
  end
end
