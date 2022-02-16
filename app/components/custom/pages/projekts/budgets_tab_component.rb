class Pages::Projekts::BudgetsTabComponent < ApplicationComponent
  delegate :render_map, to: :helpers
  attr_reader :budget

  def initialize(budget)
    @budget = budget
  end

  private

  def phases
    budget.published_phases
  end

  def phase_dom_id(phase)
    "phase-#{phases.index(phase) + 1}-#{phase.name.parameterize}"
  end

  def coordinates
    return unless budget.present?

    if budget.publishing_prices_or_later? && budget.investments.selected.any?
      investments = budget.investments.selected
    else
      investments = budget.investments
    end

    MapLocation.where(investment_id: investments).map(&:json_data)
  end
end
