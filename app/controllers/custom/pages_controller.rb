require_dependency Rails.root.join("app", "controllers", "pages_controller").to_s

class PagesController < ApplicationController
  include CommentableActions
  include HasOrders
  include CustomHelper
  include ProposalsHelper

  has_orders %w[most_voted newest oldest], only: [ :show, :comment_phase_footer_tab ]
  has_orders ->(c) { Proposal.proposals_orders(c.current_user) }, only: :proposal_phase_footer_tab
  has_orders ->(c) { Debate.debates_orders(c.current_user) }, only: :debate_phase_footer_tab
  has_filters %w[all current], only: :voting_phase_footer_tab

  def show
    @custom_page = SiteCustomization::Page.published.find_by(slug: params[:id])

    set_resource_instance

    if @custom_page.present? && @custom_page.projekt.present?
      @projekt = @custom_page.projekt
      @proposals_coordinates = all_projekt_proposals_map_locations(@custom_page.projekt)

      scoped_projekt_ids = @projekt.all_children_projekts.unshift(@projekt).pluck(:id)
      @comments_count = @projekt.comments.count
      @debates_count = Debate.base_selection(scoped_projekt_ids).count
      @proposals_count = Proposal.base_selection(scoped_projekt_ids).count
      @polls_count = Poll.base_selection(scoped_projekt_ids).count

      @most_active_proposals = Proposal.published.not_archived.where(projekt: @custom_page.projekt).sort_by_hot_score.limit(3)
      set_proposal_votes(@most_active_proposals)

      @most_active_debates = Debate.where(projekt: @custom_page.projekt).sort_by_hot_score.limit(3)
      set_debate_votes(@most_active_debates)

      @latest_polls = Poll.where(projekt: @custom_page.projekt.all_children_ids.push(@custom_page.projekt.id)).order(created_at: :asc).limit(3)

      @cards = @custom_page.cards

      @geozones = Geozone.all

      @selected_geozone_affiliation = params[:geozone_affiliation] || 'all_resources'
      @affiliated_geozones = (params[:affiliated_geozones] || '').split(',').map(&:to_i)

      @selected_geozone_restriction = params[:geozone_restriction] || 'no_restriction'
      @restricted_geozones = (params[:restricted_geozones] || '').split(',').map(&:to_i)

      @rss_id = ProjektSetting.find_by(projekt: @custom_page.projekt, key: "projekt_newsfeed.id").value
      @rss_type = ProjektSetting.find_by(projekt: @custom_page.projekt, key: "projekt_newsfeed.type").value

      render action: :custom_page
    elsif @custom_page.present?
      @cards = @custom_page.cards
      render action: :custom_page
    else
      render action: params[:id]
    end
  rescue ActionView::MissingTemplate
    head 404, content_type: "text/html"
  end

  def comment_phase_footer_tab
    @current_projekt = Projekt.find(params[:id])
    @current_tab_phase = @current_projekt.comment_phase

    @commentable = @current_projekt
    @comment_tree = CommentTree.new(@commentable, params[:page], @current_order)
    set_comment_flags(@comment_tree.comments)

    respond_to do |format|
      format.js { render "pages/projekt_footer/footer_tab" }
    end
  end

  def debate_phase_footer_tab
    @current_projekt = Projekt.find(params[:id])
    @current_tab_phase = @current_projekt.debate_phase

    @selected_parent_projekt = @current_projekt

    scoped_projekt_ids = @current_projekt.all_children_projekts.unshift(@current_projekt).pluck(:id)

    @current_order = params[:order] || @valid_orders.first
    @valid_orders.delete("archival_date")

    @all_resources = Debate.base_selection(scoped_projekt_ids)

    take_by_projekts
    set_top_level_projekts

    set_debate_votes(@all_resources)

    @debates = @all_resources.page(params[:page]).send("sort_by_#{@current_order}")

    respond_to do |format|
      format.js { render "pages/projekt_footer/footer_tab" }
    end
  end

  def proposal_phase_footer_tab
    @current_projekt = Projekt.find(params[:id])
    @current_tab_phase = @current_projekt.proposal_phase

    @selected_parent_projekt = @current_projekt

    scoped_projekt_ids = @current_projekt.all_children_projekts.unshift(@current_projekt).pluck(:id)

    @current_order = params[:order] || @valid_orders.first
    @valid_orders.delete("archival_date")

    @all_resources = Proposal.base_selection(scoped_projekt_ids)

    take_by_projekts
    set_top_level_projekts

    set_proposal_votes(@all_resources)

    @proposals_coordinates = all_proposal_map_locations(@all_resources)

    @proposals = @all_resources.page(params[:page]).send("sort_by_#{@current_order}")

    respond_to do |format|
      format.js { render "pages/projekt_footer/footer_tab" }
    end
  end

  def voting_phase_footer_tab
    @current_projekt = Projekt.find(params[:id])
    @current_tab_phase = @current_projekt.voting_phase
    @selected_parent_projekt = @current_projekt

    scoped_projekt_ids = @current_projekt.all_children_projekts.unshift(@current_projekt).pluck(:id)

    @all_resources = Poll.base_selection(scoped_projekt_ids).send(@current_filter)

    take_by_projekts
    set_top_level_projekts

    @polls = Kaminari.paginate_array(@all_resources.sort_for_list).page(params[:page])

    respond_to do |format|
      format.js { render "pages/projekt_footer/footer_tab" }
    end
  end

  def budget_phase_footer_tab
    @current_projekt = Projekt.find(params[:id])
    @current_tab_phase = @current_projekt.budget_phase

    params[:filter_projekt_id] ||= params[:id]

    @budget = Budget.find_by(projekt_id: params[:filter_projekt_id])

    query = Budget::Ballot.where(user: current_user, budget: @budget)
    @ballot = @budget.balloting? ? query.first_or_create! : query.first_or_initialize

    @investments = @budget.investments
    @investment_ids = @investments.ids

    if @budget.present? && @current_projekt.current?
      @top_level_active_projekts = Projekt.where( id: @current_projekt )
      @top_level_archived_projekts = []
    elsif @budget.present? && @current_projekt.expired?
      @top_level_active_projekts = []
      @top_level_archived_projekts = Projekt.where( id: @current_projekt )
    else
      @top_level_active_projekts = []
      @top_level_archived_projekts = []
    end

    respond_to do |format|
      format.js { render "pages/projekt_footer/footer_tab" }
    end
  end

  private

  def resource_model
    SiteCustomization::Page
  end

  def resource_name
    "page"
  end

  def take_by_projekts
    if params[:filter_projekt_ids].present?
      @all_resources = @all_resources.where(projekt_id: params[:filter_projekt_ids]).distinct
    end
  end

  def set_top_level_projekts
    @top_level_active_projekts = Projekt.where( id: @current_projekt ).selectable_in_sidebar_current(@current_tab_phase.resources_name)
    @top_level_archived_projekts = Projekt.where( id: @current_projekt ).selectable_in_sidebar_expired(@current_tab_phase.resources_name)
  end
end
