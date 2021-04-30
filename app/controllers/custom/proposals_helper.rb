require_dependency Rails.root.join("app", "helpers", "proposals_helper").to_s

module ProposalsHelper

  def all_proposal_map_locations
    @resources ||= []
    ids = @resources.map { |resource| resource.id }.uniq

    MapLocation.where(proposal_id: ids).map(&:json_data)
  end

  def json_data
    proposal = Proposal.find(params[:id])
    data = {
      proposal_id: proposal.id,
      proposal_title: proposal.title
    }.to_json

    respond_to do |format|
      format.json { render json: data }
    end
  end

  def withdraw_proposal_support_on?
    Setting["extended_feature.enable_proposal_support_withdrawal"]
  end
end
