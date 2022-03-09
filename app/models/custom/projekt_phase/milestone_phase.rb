class ProjektPhase::MilestonePhase < ProjektPhase
  def phase_activated?
    ProjektSetting.find_by(projekt: projekt, key: "projekt_feature.phase.milestone").value.present?
  end

  def phase_info_activated?
    true
  end

  def name
    'milestone_phase'
  end

  def resources_name
    'milestones'
  end
end
