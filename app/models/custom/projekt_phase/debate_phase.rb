class ProjektPhase::DebatePhase < ProjektPhase
  def phase_activated?
    ProjektSetting.find_by(projekt: projekt, key: "projekt_feature.phase.debate").presence
  end
end
