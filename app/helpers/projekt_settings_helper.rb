module ProjektSettingsHelper
  def projekt_feature?(projekt, feature)
    setting = ProjektSetting.find_by(projekt: projekt, key: "projekt_feature.#{feature}")
    (setting && (setting.value == 'active' || setting.value == 't'  )) ? true : false
  end

  def disable_feature?(projekt, projekt_setting)
    return true if ( !@projekt.top_level? && ( projekt_setting.key == "projekt_feature.general.show_in_navigation" ))
    return true if ( !@projekt.top_level? && ( projekt_setting.key == "projekt_feature.main.activate" ))

    footer_tab_setting_keys = ['projekt_feature.footer.show_activity_in_projekt_footer', 'projekt_feature.footer.show_comments_in_projekt_footer', 'projekt_feature.footer.show_notifications_in_projekt_footer', 'projekt_feature.footer.show_milestones_in_projekt_footer', 'projekt_feature.footer.show_newsfeed_in_projekt_footer']
    return true if ( !projekt_feature?(projekt, 'footer.show_projekt_footer') && footer_tab_setting_keys.include?(projekt_setting.key) )
    false
  end

  def show_projekt_phase_in_projekt_page?(projekt, phase_name)
    projekt.send(phase_name).present? && ( projekt_feature?(projekt, "general.show_not_active_phases_in_projekts_page_sidebar") || projekt_phase_active?(projekt, phase_name) )
  end

  def active_tab_in_projekt_footer?(projekt, tab)
    if projekt_feature?(projekt, 'footer.show_activity_in_projekt_footer')
      active_tab = 'activity'
    elsif  projekt_feature?(projekt, 'footer.show_comments_in_projekt_footer')
      active_tab = 'comments'
    elsif  projekt_feature?(projekt, 'footer.show_notifications_in_projekt_footer')
      active_tab = 'notifications'
    elsif  projekt_feature?(projekt, 'footer.show_milestones_in_projekt_footer')
      active_tab = 'milestones'
    elsif  projekt_feature?(projekt, 'footer.show_newsfeed_in_projekt_footer')
      active_tab = 'newsfeed'
    end

    active_tab == tab ? 'is-active' : ''
  end

  def active_tab_in_activity?(projekt, tab)
    if show_projekt_phase_in_projekt_page?(projekt, 'proposal_phase')
      active_tab = 'proposals'
    elsif show_projekt_phase_in_projekt_page?(projekt, 'debate_phase')
      active_tab = 'debates'
    elsif ( projekt_feature?(projekt, "general.show_not_active_phases_in_projekts_page_sidebar") || related_polls(projekt).count > 0 )
      active_tab = 'polls'
    end

    active_tab == tab ? 'is-active' : ''
  end
end
