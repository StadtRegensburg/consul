class ProjektPhase::BudgetPhase < ProjektPhase
  def phase_activated?
    ProjektSetting.find_by(projekt: projekt, key: "projekt_feature.phase.budget").presence
  end
end
