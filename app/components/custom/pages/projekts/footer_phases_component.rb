class Pages::Projekts::FooterPhasesComponent < ApplicationComponent
  delegate :format_date_range, :get_projekt_affiliation_name, :get_projekt_phase_restriction_name, to: :helpers
  attr_reader :projekt, :default_phase_name, :phases, :milestone_phase

  def initialize(projekt, default_phase_name)
    @projekt = projekt
    default_phase = ProjektSetting.find_by(projekt: projekt, key: 'projekt_custom_feature.default_footer_tab')
    @default_phase_name = ProjektPhase.find(default_phase.value).resources_name

    @phases = projekt.regular_projekt_phases.order(:start_date)
    @milestone_phase = projekt.milestone_phase
  end

  private

  def phase_name(phase)
    t("custom.projekts.phase_name.#{phase.name}")
  end
end
