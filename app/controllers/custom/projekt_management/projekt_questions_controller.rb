class ProjektManagement::ProjektQuestionsController < ProjektManagement::BaseController

  skip_authorization_check

  def new
    @projekt = Projekt.find(params[:projekt_id])
    @projekt_question = ProjektQuestion.new(projekt_id: @projekt.id)

    render 'admin/projekts/edit/projekt_questions/new'
  end

  def edit
    @projekt = Projekt.find(params[:projekt_id])
    @projekt_question = ProjektQuestion.find(params[:id])

    render 'admin/projekts/edit/projekt_questions/edit'
  end
end
