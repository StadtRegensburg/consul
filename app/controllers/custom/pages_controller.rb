require_dependency Rails.root.join("app", "controllers", "pages_controller").to_s

class PagesController < ApplicationController
  include CommentableActions
  include HasOrders
  include CustomHelper
  include ProposalsHelper

  has_orders %w[most_voted newest oldest], only: :show
  has_orders ->(c) { Proposal.proposals_orders(c.current_user) }, only: :proposals_footer_tab

  def show
    @custom_page = SiteCustomization::Page.published.find_by(slug: params[:id])

    if @custom_page.respond_to?(:comments)
      @commentable = @custom_page
      @comment_tree = CommentTree.new(@commentable, params[:page], @current_order)
      set_comment_flags(@comment_tree.comments)
    end

    set_resource_instance

    if @custom_page.present? && @custom_page.projekt.present?
      @projekt = @custom_page.projekt
      @proposals_coordinates = all_projekt_proposals_map_locations(@custom_page.projekt)

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

  def debates_footer_tab
    @debates = Debate.last(3)

    respond_to do |format|
      format.js { render "pages/projekt_footer/debates_footer_tab" }
    end
  end

  def proposals_footer_tab
    @current_projekt = Projekt.find(params[:id])
    @selected_parent_projekt = @current_projekt

    @current_projekt_footer_tab = "proposals"

    scoped_projekt_ids = @current_projekt.all_children_projekts.unshift(@current_projekt)

    @current_order = params[:order] || @valid_orders.first
    @valid_orders.delete("archival_date")

    @all_resources = Proposal.
      published.
      not_archived.
      not_retired.
      where(projekt_id: scoped_projekt_ids).
      joins(:projekt).merge(Projekt.activated)

    take_by_projekts

    set_proposal_votes(@all_resources)

    @proposals_coordinates = all_proposal_map_locations(@all_resources)

    @proposals = @all_resources.page(params[:page]).send("sort_by_#{@current_order}")

    @top_level_active_projekts = Projekt.where( id: @current_projekt ).selectable_in_sidebar_current('proposals')
    @top_level_archived_projekts = Projekt.where( id: @current_projekt ).selectable_in_sidebar_expired('proposals')

    respond_to do |format|
      format.js { render "pages/projekt_footer/proposals_footer_tab" }
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
      @all_resources = @all_resources.where(projekt_id: params[:filter_projekt_ids].split(',')).distinct
    end
  end


end
