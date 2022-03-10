class ProjektPhase::BudgetPhase < ProjektPhase
  def phase_activated?
    ProjektSetting.find_by(projekt: projekt, key: "projekt_feature.phase.budget").value.present?
  end

  def phase_info_activated?
    ProjektSetting.find_by(projekt: projekt, key: "projekt_feature.footer.budget_info").value.present?
  end

  def name
    'budget_phase'
  end

  def resources_name
    'budget'
  end
end
