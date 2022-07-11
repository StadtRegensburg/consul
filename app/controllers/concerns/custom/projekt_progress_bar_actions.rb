module ProjektProgressBarActions
  extend ActiveSupport::Concern
  include Translatable

  included do
    before_action :load_progressable
    before_action :load_progress_bar, only: [:edit, :update, :destroy]
    helper_method :progress_bars_index, :progressable_path
  end

  def index
    render 'admin/projekts/edit/projekt_progress_bars/index'
  end

  def new
    @progress_bar = @progressable.progress_bars.new

    render 'admin/projekts/edit/projekt_progress_bars/new'
  end

  def create
    @progress_bar = @progressable.progress_bars.new(progress_bar_params)

    if @progress_bar.save
        redirect_to namespaced_polymorphic_path(params[:namespace], @progressable.progress_bars.new ) + "#tab-projekt-milestones", notice: t("admin.progress_bars.create.notice")
    else
      render 'admin/projekts/edit/projekt_progress_bars/new'
    end
  end

  def edit
    render 'admin/projekts/edit/projekt_progress_bars/edit'
  end

  def update
    if @progress_bar.update(progress_bar_params)
      redirect_to namespaced_polymorphic_path( params[:namespace], @progressable.progress_bars.new ) + "#tab-projekt-milestones", notice: t("admin.progress_bars.update.notice")
    else
      render 'admin/projekts/edit/projekt_progress_bars/new'
    end
  end

  def destroy
    @progress_bar.destroy!

    namespace = params[:controller].split('/').first
		redirect_to namespaced_polymorphic_path( namespace, @progressable.progress_bars.new ) + "#tab-projekt-milestones", notice: t("admin.progress_bars.delete.notice")
  end

  private

    def progress_bar_params
      params.require(:progress_bar).permit(allowed_params)
    end

    def allowed_params
      [
        :kind,
        :percentage,
        translation_params(ProgressBar)
      ]
    end

    def load_progressable
      @progressable = progressable
    end

    def load_progress_bar
      @progress_bar = progressable.progress_bars.find(params[:id])
    end

    def progressable_path
      namespace = params[:controller].split('/').first
      namespaced_polymorphic_path(namespace, @progressable, action: :edit) + "#tab-projekt-milestones"
    end

    def progress_bars_index
      namespace = params[:controller].split('/').first

			namespaced_polymorphic_path(namespace, @progressable.progress_bars.new)
    end

    def progressable
      Projekt.find(params[:projekt_id])
    end
end
