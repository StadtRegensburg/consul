class DeficiencyReportsController < ApplicationController
  include Translatable

  before_action :authenticate_user!, except: [:index]
  before_action :load_categories
  load_and_authorize_resource

  def index
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
