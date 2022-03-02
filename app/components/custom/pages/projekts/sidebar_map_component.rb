class Pages::Projekts::SidebarMapComponent < ApplicationComponent
  delegate :render_map, to: :helpers
  attr_reader :projekt

  def initialize(projekt)
    @projekt = projekt

    scoped_projekt_ids = @projekt.all_children_projekts.unshift(@projekt).pluck(:id)
    scoped_proposal_ids = Proposal.base_selection.ids
    @proposals_coordinates = MapLocation.where(proposal_id: scoped_proposal_ids).map(&:json_data)
  end

  private
end
