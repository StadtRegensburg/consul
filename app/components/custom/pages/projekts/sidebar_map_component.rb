class Pages::Projekts::SidebarMapComponent < ApplicationComponent
  delegate :render_map, to: :helpers
  attr_reader :projekt

  def initialize(projekt)
    @projekt = projekt
  end

  private
end
