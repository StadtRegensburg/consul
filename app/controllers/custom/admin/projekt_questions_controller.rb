class Admin::ProjektQuestionsController < Admin::BaseController
  include Translatable

  before_action :set_projekt, only: [:new, :create]
  before_action :set_projekt_and_projekt_question, except: [:new, :create]

  skip_authorization_check

  load_and_authorize_resource :projekt
  load_and_authorize_resource :question, class: "ProjektQuestion", through: :projekt

  def new
    @projekt_question = ProjektQuestion.new(projekt_id: @projekt.id)

    render "admin/projekts/edit/projekt_questions/new"
  end

  def create
    @projekt_question = ProjektQuestion.new(projekt_question_params)
    @projekt_question.projekt_id = @projekt.id
    @projekt_question.author = current_user

    if @projekt_question.save
      notice = "Question created"
      redirect_to redirect_path(@projekt.id, "#tab-projekt-questions"), notice: notice
    else
      flash.now[:error] = t("admin.legislation.questions.create.error")
      render "admin/projekts/edit/projekt_questions/new"
    end
  end

  def edit
    @projekt_question = ProjektQuestion.find(params[:id])

    render "admin/projekts/edit/projekt_questions/edit"
  end

  def update
    if @projekt_question.update(projekt_question_params)
      notice = "Question updated"
      redirect_to redirect_path(@projekt.id, "#tab-projekt-questions"), notice: notice
    else
      flash.now[:error] = t("admin.legislation.questions.update.error")
      render :edit
    end
  end

  def destroy
    @projekt_question.destroy!

    redirect_to redirect_path(@projekt.id, "#tab-projekt-questions"),
      notice: t("admin.legislation.questions.destroy.notice")
  end

  private

    def question_path
      legislation_process_question_path(@process, @projekt_question)
    end

    def projekt_question_params
      params.require(:projekt_question).permit(
        translation_params(::ProjektQuestion),
        :comments_enabled, :show_answers_count,
        question_options_attributes: [
          :id, :_destroy, translation_params(::ProjektQuestionOption)
        ]
      )
    end

    def set_projekt_and_projekt_question
      @projekt = Projekt.find(params[:projekt_id])
      @projekt_question = ProjektQuestion.find(params[:id])
    end

    def set_projekt
      @projekt = Projekt.find(params[:projekt_id])
    end

    def redirect_path(projekt_id, tab)
      if params[:namespace] == "projekt_management"
        edit_projekt_management_projekt_path(projekt_id) + tab
      else
        edit_admin_projekt_path(projekt_id) + tab
      end
    end
end
