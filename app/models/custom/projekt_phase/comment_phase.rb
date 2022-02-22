class ProjektPhase::CommentPhase < ProjektPhase
  def phase_activated?
    ProjektSetting.find_by(projekt: projekt, key: "projekt_feature.phase.comment").presence
  end
end
