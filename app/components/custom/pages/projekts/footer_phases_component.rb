class Pages::Projekts::FooterPhasesComponent < ApplicationComponent
  delegate :format_date_range, :get_projekt_affiliation_name, :get_projekt_phase_restriction_name, to: :helpers
  attr_reader :projekt, :phases

  def initialize(projekt)
    @projekt = projekt
    @phases = projekt.projekt_phases.order(:start_date)
  end

  private

  def phase_name(phase)
    t("custom.projekts.phase_name.#{phase.name}")
  end
end
