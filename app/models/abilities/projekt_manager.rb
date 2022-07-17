module Abilities
  class ProjektManager
    include CanCan::Ability

    def self.common_administration_blocks
      [MapLayer, ProjektQuestion, ProjektNotification, ProjektEvent, Milestone, ProgressBar]
    end

    def initialize(user)
      merge Abilities::Common.new(user)

      can([:show, :update, :update_map], Projekt) { |p| p.projekt_manager_id == user.projekt_manager.id }

      can(:update, ProjektSetting) { |ps| ps.projekt.projekt_manager_id == user.projekt_manager.id }

      can(:update_map, MapLocation) { |p| p.projekt.projekt_manager_id == user.projekt_manager.id }

      can(%i[read update], SiteCustomization::Page) do |p|
        p.projekt.present? &&
        p.projekt.projekt_manager_id == user.projekt_manager.id
      end

      can(:manage, ::Widget::Card) do |wc|
        wc.cardable.class == SiteCustomization::Page &&
        wc.cardable.projekt.present? &&
        wc.cardable.projekt.projekt_manager_id == user.projekt_manager.id
      end

      can(:manage, ProjektManager.common_administration_blocks) do |resource|
        resource.projekt.present? &&
        resource.projekt.projekt_manager_id == user.projekt_manager.id
      end
    end
  end
end
