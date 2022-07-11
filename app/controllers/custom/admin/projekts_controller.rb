class Admin::ProjektsController < Admin::BaseController
  include MapLocationAttributes
  include Translatable
  include ImageAttributes
  include ProjektAdminActions

  before_action :find_projekt, only: [:update, :liveupdate, :destroy, :quick_update]
  before_action :load_geozones, only: [:new, :create, :edit, :update]
  before_action :process_tags, only: [:update]

  def index
    @projekts = Projekt.top_level
    @projekt = Projekt.new

    @projekts_settings = Setting.all.group_by(&:type)['projekts']
    skip_user_verification_setting = Setting.find_by(key: 'feature.user.skip_verification')
    @projekts_settings.push(skip_user_verification_setting)

    @map_configuration_settings = Setting.all.group_by(&:type)['map']
    @geozones = Geozone.all.order(Arel.sql("LOWER(name)"))
  end

  def show
    redirect_to edit_admin_projekt_path
  end

  def quick_update
    @projekt.update_attributes(projekt_params)
    Projekt.ensure_order_integrity

    redirect_back(fallback_location: admin_projekts_path)
  end

  def update
    if @projekt.update_attributes(projekt_params)
      redirect_to redirect_path(params[:id], params[:tab].to_s), notice: t("admin.settings.index.map.flash.update")
    else
      redirect_to redirect_path(params[:id], params[:tab].to_s), alert: @projekt.errors.messages.values.flatten.join('; ')
    end
  end

  def liveupdate
    @projekt.update_attributes(projekt_params)
  end

  def update_map
    map_location = MapLocation.find_by(projekt: params[:projekt_id])
    map_location.update(map_location_params)

    redirect_to redirect_path(params[:projekt_id], '#tab-projekt-map'), notice: t("admin.settings.index.map.flash.update")
  end

  def create
    @projekts = Projekt.top_level.page(params[:page])
    @projekt = Projekt.new(projekt_params.merge(color: "#073E8E"))
    @projekt.order_number = 0

    if @projekt.save
      Projekt.ensure_order_integrity
      redirect_to admin_projekts_path
    else
      render :index
    end
  end

  def destroy
    @projekt.children.each do |child|
      child.update(parent: nil)
    end
    @projekt.debates.unscope(where: :hidden_at).each do |debate|
      debate.update(projekt_id: nil)
    end
    @projekt.proposals.unscope(where: :hidden_at).each do |proposal|
      proposal.update(projekt_id: nil)
    end
    @projekt.polls.unscope(where: :hidden_at).each do |poll|
      poll.update(projekt_id: nil)
    end
    @projekt.destroy!
    redirect_to admin_projekts_path
  end

  def order_up
    @projekt = Projekt.find(params[:id])
    @projekt.order_up
    redirect_to admin_projekts_path
  end

  def order_down
    @projekt = Projekt.find(params[:id])
    @projekt.order_down
    redirect_to admin_projekts_path
  end

  def update_standard_phase
    @projekt = Projekt.find(params[:id])
    @default_footer_tab_setting = ProjektSetting.find_by(projekt: @projekt, key: 'projekt_custom_feature.default_footer_tab')

    if @default_footer_tab_setting.present?
      @default_footer_tab_setting.update(value: params[:default_footer_tab][:id])
    end

    respond_to do |format|
      format.js
    end
  end

  private

  def projekt_params
    attributes = [
      :name, :parent_id, :total_duration_start, :total_duration_end, :color, :icon, :geozone_affiliated, :tag_list, :related_sdg_list, geozone_affiliation_ids: [], sdg_goal_ids: [],
      comment_phase_attributes: [:id, :start_date, :end_date, :geozone_restricted, :active, geozone_restriction_ids: [] ],
      debate_phase_attributes: [:id, :start_date, :end_date, :geozone_restricted, :active, geozone_restriction_ids: [] ],
      proposal_phase_attributes: [:id, :start_date, :end_date, :geozone_restricted, :active, geozone_restriction_ids: [] ],
      budget_phase_attributes: [:id, :start_date, :end_date, :geozone_restricted, :active, geozone_restriction_ids: [] ],
      voting_phase_attributes: [:id, :start_date, :end_date, :geozone_restricted, :active, geozone_restriction_ids: [] ],
      legislation_process_phase_attributes: [:id, :start_date, :end_date, :geozone_restricted, :active, geozone_restriction_ids: [] ],
      milestone_phase_attributes: [:id, :start_date, :end_date, :active],
      newsfeed_phase_attributes: [:id, :start_date, :end_date, :active],
      event_phase_attributes: [:id, :start_date, :end_date, :active],
      question_phase_attributes: [:id, :start_date, :end_date, :active],
      projekt_notification_phase_attributes: [:id, :start_date, :end_date, :active],
      map_location_attributes: map_location_attributes,
      image_attributes: image_attributes,
      projekt_notifications: [:title, :body],
      project_events: [:id, :title, :location, :datetime, :weblink],
    ]
    params.require(:projekt).permit(attributes, translation_params(Projekt))
  end

  def process_tags
    params[:projekt][:tag_list] = (params[:projekt][:tag_list_predefined] || "")
    params[:projekt].delete(:tag_list_predefined)
  end

  def map_location_params
    if params[:map_location]
      params.require(:map_location).permit(map_location_attributes)
    else
      params.permit(map_location_attributes)
    end
  end

  def find_projekt
    @projekt = Projekt.find(params[:id])
  end

  def load_geozones
    @geozones = Geozone.all.order(:name)
  end

  def redirect_path(projekt_id, tab)
    if params[:namespace] == 'projekt_management'
      edit_projekt_management_projekt_path(projekt_id) + tab
    else
      edit_admin_projekt_path(projekt_id) + tab
    end
  end
end
