require_dependency Rails.root.join("app", "components", "admin", "menu_component").to_s

class Admin::MenuComponent < ApplicationComponent
  include LinkListHelper

  private

    def deficiency_reports?
      params[:controller] == params[:controller] &&
        (
          action_name == "officers"
          action_name == "reports"
          action_name == "categories"
          action_name == "status"
          action_name == "settings"
        )
    end

    def deficiency_reports_officers
      [
        t("custom.admin.menu.deficiency_reports.officers"),
        admin_deficiency_reports_officers_path,
        %w[shifts booths].include?(controller_name) && %w[available new].include?(action_name)
      ]
    end

    def deficiency_reports
      [
        t("custom.admin.menu.deficiency_reports.reports"),
        admin_deficiency_reports_path,
        %w[shifts booths].include?(controller_name) && %w[available new].include?(action_name)
      ]
    end

    def deficiency_reports_categories
      [
        t("custom.admin.menu.deficiency_reports.categories"),
        admin_deficiency_reports_categories_path,
        %w[shifts booths].include?(controller_name) && %w[available new].include?(action_name)
      ]
    end

    def deficiency_reports_statuses
      [
        t("custom.admin.menu.deficiency_reports.statuses"),
        admin_deficiency_reports_statuses_path,
        %w[shifts booths].include?(controller_name) && %w[available new].include?(action_name)
      ]
    end

    def deficiency_reports_settings
      [
        t("custom.admin.menu.deficiency_reports.settings"),
        admin_deficiency_reports_settings_path,
        %w[shifts booths].include?(controller_name) && %w[available new].include?(action_name)
      ]
    end
end
