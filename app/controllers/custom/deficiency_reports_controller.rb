class DeficiencyReportsController < ApplicationController
  include Translatable

  before_action :authenticate_user!, except: [:index]
  before_action :load_categories
  load_and_authorize_resource

  has_orders %w[created_at]

  def index
    @valid_orders = []
    @deficiency_reports = DeficiencyReport.all.page(params[:page]).send("sort_by_#{@current_order}")

    @selected_tags = all_selected_tags

    @top_level_active_projekts = Projekt.top_level_active.select{ |projekt| projekt.all_children_projekts.unshift(projekt).any? { |p| p.has_active_phase?('proposals') || p.proposals.any? } }
    @top_level_archived_projekts = Projekt.top_level_archived.select{ |projekt| projekt.all_children_projekts.unshift(projekt).any? { |p| p.has_active_phase?('proposals') || p.proposals.any? } }
  end

  def new
    @deficiency_report = DeficiencyReport.new
  end

  def create
    @deficiency_report = DeficiencyReport.new(deficiency_report_params)

    if @deficiency_report.save
      redirect_to deficiency_reports_path
    else
      render :new
    end
  end

  private

  def load_categories
    @categories = Tag.category.order(:name)
  end

  def deficiency_report_params
    attributes = [:terms_of_service, :tag_list, :terms_of_service, :projekt_id, :related_sdg_list]
    params.require(:deficiency_report).permit(attributes, translation_params(DeficiencyReport))
  end
end
