class Abilities::DeficiencyReport::Officer
  include CanCan::Ability

  def initialize(user)
    merge Abilities::Common.new(user)

    dr_officer = user.deficiency_report_officer

    can [:read, :json_data], DeficiencyReport
    can :update_official_answer, DeficiencyReport, officer: dr_officer
  end
end
