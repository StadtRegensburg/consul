class Sidebar::ProjektsFilterOptionComponent < ApplicationComponent
  delegate :projekt_filter_resources_name, to: :helpers

  def initialize(f, projekt, group, all_resources)
    @f = f
    @projekt = projekt
    @group = group
    @all_resources = all_resources
  end

	private

  def f
    @f
  end

  def projekt
    @projekt
  end

  def resource_count
    @all_resources.where(projekt: projekt.selectable_tree_ids(projekt_filter_resources_name, @group)).count
  end

  def selectable_children
    if @group == 'active'
      @projekt.children.selectable_in_sidebar_current(projekt_filter_resources_name)
    elsif group == 'archived'
      @projekt.children.selectable_in_sidebar_expired(projekt_filter_resources_name)
    end
  end

  def label_class
    if @selected_projekts_ids && projekt.id.to_s.in?(@selected_projekts_ids)
      'label-selected'
    else
      'label_regular'
    end
  end

  def checkbox_checked
    @selected_projekts_ids && projekt.id.to_s.in?(@selected_projekts_ids)
  end
end
