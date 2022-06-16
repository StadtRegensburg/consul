class ProjektPhase::VotingPhase < ProjektPhase
  def phase_activated?
    projekt.polls.any?# { |poll| poll.current? }
  end

  def name
    'voting_phase'
  end

  def resources_name
    'polls'
  end

  def default_order
    4
  end
end
