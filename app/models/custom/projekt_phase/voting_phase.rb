class ProjektPhase::VotingPhase < ProjektPhase
  def phase_activated?
    true
  end

  def phase_info_activated?
    ProjektSetting.find_by(projekt: projekt, key: "projekt_feature.phase.voting_info").value.present?
  end

  def name
    'voting_phase'
  end

  def resources_name
    'polls'
  end
end
