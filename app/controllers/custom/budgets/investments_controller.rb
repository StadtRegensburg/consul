require_dependency Rails.root.join("app", "controllers", "budgets", "investments_controller").to_s

module Budgets
  class InvestmentsController < ApplicationController

    def flag
      Flag.flag(current_user, @investment)
      redirect_to @investment
    end

    def unflag
      Flag.unflag(current_user, @investment)
      redirect_to @investment
    end
  end
end
