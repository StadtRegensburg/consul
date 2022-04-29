class ProjektPhase::MilestonePhase < ProjektPhase
  def phase_activated?
    activated?
  end

  def phase_info_activated?
    info_activated?
  end

  def name
    'milestone_phase'
  end

  def resources_name
    'milestones'
  end
end
