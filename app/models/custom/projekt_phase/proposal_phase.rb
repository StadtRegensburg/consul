class ProjektPhase::ProposalPhase < ProjektPhase
  def phase_activated?
    ProjektSetting.find_by(projekt: projekt, key: "projekt_feature.phase.proposal").presence
  end
end
