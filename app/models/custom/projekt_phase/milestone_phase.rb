class ProjektPhase::MilestonePhase < ProjektPhase
  def phase_activated?
    ProjektSetting.find_by(projekt: projekt, key: "projekt_feature.phase.milestone").value.present?
  end

  def name
    'milestone_phase'
  end

  def resources_name
    'milestones'
  end
end
