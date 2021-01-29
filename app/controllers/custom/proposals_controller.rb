require_dependency Rails.root.join("app", "controllers", "proposals_controller").to_s

class ProposalsController
  before_action :process_tags, only: [:create, :update]
  def index_customization
    take_only_by_tag_names
    discard_draft
    discard_archived
    load_retired
    load_selected
    load_featured
    remove_archived_from_order_links
  end
private
  def process_tags
    params[:proposal][:tag_list_categories].split(",").each do |t|
      next if t.strip.blank?
      Tag.find_or_create_by name: t.strip, kind: :category
    end
    params[:proposal][:tag_list_subcategories].split(",").each do |t|
      next if t.strip.blank?
      Tag.find_or_create_by name: t.strip, kind: :subcategory
    end
    params[:proposal][:tag_list] ||= ""
    params[:proposal][:tag_list] += ((params[:proposal][:tag_list_categories] || "").split(",") + (params[:proposal][:tag_list_subcategories] || "").split(",")).join(",")
    params[:proposal][:tag_list_categories], params[:proposal][:tag_list_subcategories] = nil, nil
  end
  def take_only_by_tag_names
    if params[:tags].present?
      @resources = @resources.tagged_with(params[:tags].split(","), all: true)
      @subcategories = @resources.tag_counts.subcategory
    end
  end
end