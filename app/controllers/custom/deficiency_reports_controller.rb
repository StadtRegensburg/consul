class DeficiencyReportsController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  load_and_authorize_resource

  def index
  end

  def new
    @deficiency_report = DeficiencyReport.new
  end
end
