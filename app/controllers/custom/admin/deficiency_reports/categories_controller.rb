class Admin::DeficiencyReports::CategoriesController < Admin::BaseController
  include Translatable
  load_and_authorize_resource :category, class: "DeficiencyReport::Category", except: :show

  def index
    @categories = DeficiencyReport::Category.all
  end

  def new
  end

  def edit
  end

  def create
    @category = DeficiencyReport::Category.new(category_params)

    if @category.save
      redirect_to admin_deficiency_report_categories_path
    else
      render :new
    end
  end

  def update
    if @category.update(category_params)
      redirect_to admin_deficiency_report_categories_path
    else
      render :edit
    end
  end

  def destroy
    @category.destroy!
    redirect_to admin_deficiency_report_categories_path
  end

  private

  def category_params
    params.require(:deficiency_report_category).permit(:color, translation_params(DeficiencyReport::Category))
  end
end
