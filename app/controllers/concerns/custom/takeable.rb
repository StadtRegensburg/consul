module Takeable
  extend ActiveSupport::Concern

  def take_by_tag_names
    if params[:tags].present?
      @resources = @resources.tagged_with(params[:tags].split(","), all: true, any: :true)
    end
  end

  def take_by_projekts
    if params[:filter_projekt_ids].present?
      selected_projekts_ids = params[:filter_projekt_ids].select{ |id| Projekt.find_by(id: id).present? }
      selected_parent_projekt_id = get_highest_unique_parent_projekt_id(selected_projekts_ids)
      @selected_parent_projekt = Projekt.find_by(id: selected_parent_projekt_id)

      @resources = @resources.where(projekt_id: params[:filter_projekt_ids].split(',')).distinct
    end
  end

  def take_by_sdgs
    if params[:sdg_targets].present?
			@filtered_target = params[:sdg_targets].split(',')[0]
      @resources = @resources.joins(:sdg_global_targets).where(sdg_targets: { code: params[:sdg_targets].split(',')[0] }).distinct
      return
    end

    if params[:sdg_goals].present?
			@filtered_goals = params[:sdg_goals].split(',').map{ |code| code.to_i }
      @resources = @resources.joins(:sdg_goals).where(sdg_goals: { code: params[:sdg_goals].split(',') }).distinct
    end
  end

  def take_by_geozone_affiliations
    case @selected_geozone_affiliation
    when 'all_resources'
      @resources
    when 'no_affiliation'
      @resources = @resources.joins(:projekt).where( projekts: { geozone_affiliated: 'no_affiliation' } ).distinct
    when 'entire_city'
      @resources = @resources.joins(:projekt).where(projekts: { geozone_affiliated: 'entire_city' } ).distinct
    when 'only_geozones'
      @resources = @resources.joins(:projekt).where(projekts: { geozone_affiliated: 'only_geozones' } ).distinct
      if @affiliated_geozones.present?
        @resources = @resources.joins(:geozone_affiliations).where(geozones: { id: @affiliated_geozones }).distinct
      else
        @resources = @resources.joins(:geozone_affiliations).where.not(geozones: { id: nil }).distinct
      end
    end
  end

  def take_by_geozone_restrictions
    case @selected_geozone_restriction
    when 'no_restriction'
      @resources = @resources.joins(:debate_phase).distinct
    when 'only_citizens'
      @resources = @resources.joins(:debate_phase).where(projekt_phases: { geozone_restricted: ['only_citizens', 'only_geozones'] }).distinct
    when 'only_geozones'
      @resources = @resources.joins(:debate_phase).where(projekt_phases: { geozone_restricted: 'only_geozones' }).distinct

      if @restricted_geozones.present?
        sql_query = "
          INNER JOIN projekts AS projekts_debates_join_for_restrictions ON projekts_debates_join_for_restrictions.hidden_at IS NULL AND projekts_debates_join_for_restrictions.id = debates.projekt_id
          INNER JOIN projekt_phases AS debate_phases_debates_join_for_restrictions ON debate_phases_debates_join_for_restrictions.projekt_id = projekts_debates_join_for_restrictions.id AND debate_phases_debates_join_for_restrictions.type IN ('ProjektPhase::DebatePhase')
          INNER JOIN projekt_phase_geozones ON projekt_phase_geozones.projekt_phase_id = debate_phases_debates_join_for_restrictions.id
          INNER JOIN geozones AS geozone_restrictions ON geozone_restrictions.id = projekt_phase_geozones.geozone_id
        "
        @resources = @resources.joins(sql_query).where(geozone_restrictions: { id: @restricted_geozones }).distinct
      end
    end
  end

  def take_by_my_posts
    if params[:my_posts_filter] == 'true'
      @resources = @resources.by_author(current_user&.id)
    end
  end

  def take_with_activated_projekt_only
    @resources = @resources.joins(:projekt).merge(Projekt.activated)
  end

  def take_when_projekt_in_sidebar_only
    scoped_projekt_ids = Projekt.ids

    @resources = @resources.where(projekt_id: scoped_projekt_ids).
      joins(:projekt).merge(Projekt.activated).
      joins( 'INNER JOIN projekt_settings shwmn ON projekts.id = shwmn.projekt_id' ).
      where( 'shwmn.key': 'projekt_feature.debates.show_in_sidebar_filter', 'shwmn.value': 'active' )

  end
end
