class Admin::ProjektQuestionsController < Admin::BaseController
  include Translatable

  before_action :set_projekt, except: :destroy

  # load_and_authorize_resource :projekt
  # load_and_authorize_resource :projekt_question, class: "ProjektQuestion", through: :projekt

  def new
    @projekt_question = ProjektQuestion.new(projekt_id: @projekt.id)

    render 'admin/projekts/edit/projekt_questions/new'
  end

  def create
    @projekt_question = ProjektQuestion.new(projekt_question_params)
    @projekt_question.projekt_id = @projekt.id

    if @projekt_question.save
      notice = 'Question created'
      redirect_to edit_admin_projekt_path(@projekt.id), notice: notice
    else
      flash.now[:error] = t("admin.legislation.questions.create.error")
      render :new
    end
  end

  def update
    if @projekt_question.update(question_params)
      notice = 'Question updated'
      redirect_to edit_admin_projekt_path(@projekt.id), notice: notice
    else
      flash.now[:error] = t("admin.legislation.questions.update.error")
      render :edit
    end
  end

  def destroy
    @projekt_question.destroy!
    notice = t("admin.legislation.questions.destroy.notice")
    redirect_to admin_legislation_process_questions_path, notice: notice
  end

  private

    def question_path
      legislation_process_question_path(@process, @projekt_question)
    end

    def projekt_question_params
      params.require(:projekt_question).permit(
        translation_params(::ProjektQuestion),
        question_options_attributes: [
          :id, :_destroy, translation_params(::ProjektQuestionOption)
        ]
      )
    end

    def resource
      @projekt_question || ::Legislation::projekt_question.find(params[:id])
    end

  def set_projekt
    @projekt = Projekt.find(params[:projekt_id])
  end

  def request_referer
    return request.referer + params[:projekt_question][:tab] if params[:projekt_question][:tab]

    request.referer
  end
end
