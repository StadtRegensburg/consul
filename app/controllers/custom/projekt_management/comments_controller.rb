class ProjektManagement::CommentsController < ProjektManagement::BaseController
  include ModerateActions

  has_filters %w[all unseen seen], only: :index
  has_orders %w[flags newest], only: :index

  before_action :load_resources, only: [:index, :moderate]

  load_and_authorize_resource

  def index
    super

    render "moderation/comments/index"
  end

  private

    def resource_model
      Comment
    end

    def author_id
      :user_id
    end
end
