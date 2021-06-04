require_dependency Rails.root.join("app", "controllers", "pages_controller").to_s

class PagesController < ApplicationController
  include CommentableActions
  include HasOrders
  include CustomHelper

  has_orders %w[most_voted newest oldest], only: :show

  def show
    @custom_page = SiteCustomization::Page.published.find_by(slug: params[:id])

    @commentable = @custom_page
    @comment_tree = CommentTree.new(@commentable, params[:page], @current_order)
    set_resource_instance

    if @custom_page.projekt.present?
      @proposals_coordinates = all_projekt_proposals_map_locations(@custom_page.projekt)
    end
		@feeds = Widget::Feed.all

    if @custom_page.present?
      @cards = @custom_page.cards
      render action: :custom_page
    else
      render action: params[:id]
    end
  rescue ActionView::MissingTemplate
    head 404, content_type: "text/html"
  end

  private

  def resource_model
    SiteCustomization::Page
  end

  def resource_name
    "page"
  end

end
