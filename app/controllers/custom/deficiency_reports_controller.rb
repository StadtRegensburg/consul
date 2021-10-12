class DeficiencyReportsController < ApplicationController
  include Translatable
  include MapLocationAttributes
  include ImageAttributes
  include DocumentAttributes
  include DeficiencyReportsHelper

  before_action :authenticate_user!, except: [:index, :json_data]
  before_action :load_categories
  before_action :destroy_map_location_association, only: :update
  load_and_authorize_resource

  has_orders %w[created_at]

  def index
    @valid_orders = []
    @deficiency_reports = DeficiencyReport.all.page(params[:page]).send("sort_by_#{@current_order}")

    @categories = DeficiencyReport::Category.all
    @statuses = DeficiencyReport::Status.all

    @deficiency_reports_coordinates = all_deficiency_report_map_locations(@deficiency_reports)

    @selected_categories_ids = (params[:dr_categories] || '').split(',')
    @selected_status_id = (params[:dr_status] || '').split(',').first
  end

  def new
    @deficiency_report = DeficiencyReport.new
  end

  def create
    @deficiency_report = DeficiencyReport.new(deficiency_report_params.merge(author: current_user))

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
    attributes = [:terms_of_service, :video_url, :deficiency_report_category_id,
                  map_location_attributes: map_location_attributes,
                  documents_attributes: document_attributes,
                  image_attributes: image_attributes]
    params.require(:deficiency_report).permit(attributes, translation_params(DeficiencyReport))
  end


  def destroy_map_location_association
    map_location = params[:deficiency_report][:map_location_attributes]
    if map_location && (map_location[:longitude] && map_location[:latitude]).blank? && !map_location[:id].blank?
      MapLocation.destroy(map_location[:id])
    end
  end

end
