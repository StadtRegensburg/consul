class ProjektPhase::LegislationProcessPhase < ProjektPhase
  def phase_activated?
    # projekt.legislation_process.present?
    active?
  end

  def name
    'legislation_process_phase'
  end

  def resources_name
    'legislation_process'
  end

  def default_order
    3
  end
end
