class Pages::Projekts::SidebarPhasesComponent < ApplicationComponent
  delegate :format_date_range, :format_date, to: :helpers
  attr_reader :projekt, :phases, :milestone_phase

  def initialize(projekt)
    @projekt = projekt
    @phases = projekt.regular_projekt_phases.order(:start_date)
    @milestone_phase = projekt.milestone_phase
  end

  private

  def phase_name(phase, part=nil)
    return t("custom.projekts.phase_name.#{phase.name}.#{part}") if part
    t("custom.projekts.phase_name.#{phase.name}")
  end
end