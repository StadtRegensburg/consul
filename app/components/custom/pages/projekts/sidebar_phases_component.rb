class Pages::Projekts::SidebarPhasesComponent < ApplicationComponent
  delegate :format_date_range, to: :helpers
  attr_reader :projekt

  def initialize(projekt)
    @projekt = projekt
    @phases = projekt.projekt_phases.order(:start_date)
  end

  private

  def phase_name(phase)
    t("custom.projekts.phase_name.#{phase.name}")
  end
end
