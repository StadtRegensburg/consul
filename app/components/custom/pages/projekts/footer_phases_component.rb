class Pages::Projekts::FooterPhasesComponent < ApplicationComponent
  delegate :format_date_range, :get_projekt_affiliation_name, :get_projekt_phase_restriction_name, to: :helpers
  attr_reader :projekt, :default_phase_name, :phases, :milestone_phase

  def initialize(projekt, default_phase_name)
    @projekt = projekt
    @default_phase_name = default_phase_name
    @phases = projekt.projekt_phases.where.not(type: 'ProjektPhase::MilestonePhase').order(:start_date)
    @milestone_phase = projekt.projekt_phases.find_by(type: 'ProjektPhase::MilestonePhase')
  end

  private

  def phase_name(phase)
    t("custom.projekts.phase_name.#{phase.name}")
  end
end
