module ProjektAdminActions
  extend ActiveSupport::Concern

  def edit
    @projekt = Projekt.find(params[:id])

    if @projekt.map_location.nil?
      @projekt.send(:create_map_location)
      @projekt.reload
    end

    @projekt.build_comment_phase if @projekt.comment_phase.blank?
    @projekt.comment_phase.geozone_restrictions.build

    @projekt.build_debate_phase if @projekt.debate_phase.blank?
    @projekt.debate_phase.geozone_restrictions.build

    @projekt.build_proposal_phase if @projekt.proposal_phase.blank?
    @projekt.proposal_phase.geozone_restrictions.build

    @projekt.build_budget_phase if @projekt.budget_phase.blank?
    @projekt.budget_phase.geozone_restrictions.build

    @projekt.build_voting_phase if @projekt.voting_phase.blank?
    @projekt.voting_phase.geozone_restrictions.build

    @projekt.build_event_phase if @projekt.event_phase.blank?
    @projekt.event_phase.geozone_restrictions.build

    @projekt.build_map_location if @projekt.map_location.blank?

    all_settings = ProjektSetting.where(projekt: @projekt).group_by(&:type)
    all_projekt_features = all_settings["projekt_feature"].group_by(&:projekt_feature_type)
    @projekt_features_main = all_projekt_features['main']

    @projekt_features_general = all_projekt_features['general']
    @projekt_features_sidebar = all_projekt_features['sidebar']
    @projekt_features_footer = all_projekt_features['footer']
    @projekt_features_debates = all_projekt_features['debates']
    @projekt_features_proposals = all_projekt_features['proposals']
    @projekt_options_proposals = all_projekt_features['proposal_options']
    @projekt_features_polls = all_projekt_features['polls']
    @projekt_features_budgets = all_projekt_features['budgets']
    @projekt_features_milestones = all_projekt_features['milestones']

    @projekt_newsfeed_settings = all_settings["projekt_newsfeed"]

    @projekt_notification = ProjektNotification.new
    @projekt_notifications = ProjektNotification.where(projekt: @projekt).order(created_at: :desc)

    @projekt_event = ProjektEvent.new
    @projekt_events = ProjektEvent.where(projekt: @projekt).order(created_at: :desc)

    @default_footer_tab_setting = ProjektSetting.find_by(projekt: @projekt, key: 'projekt_custom_feature.default_footer_tab')
  end
end
