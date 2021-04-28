module ProjektsHelper
  def show_archived_projekts_in_sidebar?
    Setting["projekts.show_archived.sidebar"].present? ? true : false
  end

  def show_archived_projekts_in_menu?
    Setting["projekts.show_archived.navigation"].present? ? true : false
  end

  def prepare_projekt_name(projekt)
    if projekt.page.published?
      link_to projekt.name, projekt.page.url
    else
      projekt.name
    end
  end

  def prepare_projekt_modules_links(projekt)

    module_links = []

    if debate_phase_active?(projekt)
      link = link_to t('custom.menu.debates'), (debates_path + "?projekts=#{projekt.all_children_ids.push(projekt.id).join(',')}"), class: 'projekt-module-link'
      module_links.push(link)
    end

    if proposal_phase_active?(projekt)
      link = link_to t('custom.menu.proposals'), (proposals_path + "?projekts=#{projekt.all_children_ids.push(projekt.id).join(',')}"), class: 'projekt-module-link'
      module_links.push(link)
    end

    if related_polls(projekt).any?
      link = link_to t('custom.menu.polls'), (polls_path + "?projekts=#{projekt.all_children_ids.push(projekt.id).join(',')}"), class: 'projekt-module-link'
      module_links.push(link)
    end

    module_links.join(' | ').html_safe
  end

  def debate_phase_active?(projekt)
    top_parent = projekt.top_parent

    return false unless ( top_parent.debate_phase.start_date || top_parent.total_duration_start )
    return false unless ( top_parent.debate_phase.end_date || top_parent.total_duration_end )

    if top_parent.debate_phase.active && (top_parent.debate_phase.start_date || top_parent.total_duration_start) < Date.today && (top_parent.debate_phase.end_date || top_parent.total_duration_end ) > Date.today
			return true
    else
			return false
    end
  end

  def proposal_phase_active?(projekt)
    top_parent = projekt.top_parent

    return false unless ( top_parent.proposal_phase.start_date || top_parent.total_duration_start )
    return false unless ( top_parent.proposal_phase.end_date || top_parent.total_duration_end )

    if top_parent.proposal_phase.active && (top_parent.proposal_phase.start_date || top_parent.total_duration_start) < Date.today && (top_parent.proposal_phase.end_date || top_parent.total_duration_end ) > Date.today
			return true
    else
			return false
    end
  end

  def format_date(date)
    return '' if date.blank?
    date.strftime("%d.%m.%Y")
  end

  def format_date_range(start_date=nil, end_date=nil)
    if start_date && end_date
      "#{format_date(start_date)} - #{format_date(end_date)}"
    elsif start_date && !end_date
      "Start #{format_date(start_date)}"
    elsif !start_date && end_date
      "bis #{format_date(end_date)}"
    else
      'Ohne zeitliche Beschränkung'
    end
  end

  def get_projekt_phase_duration(phase)
    if phase
      format_date_range(phase.start_date, phase.end_date)
    else
      format_date_range
    end
  end

  def get_projekt_phase_limitations(phase)
    if phase
      return phase.geozones.names.join(', ') if phase.geozones.any? && phase.geozone_restricted
      return 'Alle Bürger der Stadt' if phase.geozone_restricted
    end
    'Alle Nutzer der Platform'
  end

  def related_polls(projekt, timestamp = Date.current.beginning_of_day)
    Poll.where(projekt_id: projekt.all_children_ids.push(projekt.id)).where("starts_at <= ? AND ? <= ends_at", timestamp, timestamp)
  end
end
