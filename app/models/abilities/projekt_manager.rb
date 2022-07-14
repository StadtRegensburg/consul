module Abilities
  class ProjektManager
    include CanCan::Ability

    def initialize(user)
      merge Abilities::Common.new(user)

      can :update, Projekt, projekt_manager_id: user.projekt_manager.id

      can(:update, ProjektSetting) { |ps| ps.projekt.projekt_manager_id == user.projekt_manager.id }

      can(%i[read update], SiteCustomization::Page) do |c|
        c.projekt.present? &&
        c.projekt.projekt_manager_id == user.projekt_manager.id
      end

      can(:manage, ::Widget::Card) do |c|
        c.cardable.class == SiteCustomization::Page &&
        c.cardable.projekt.present? &&
        c.cardable.projekt.projekt_manager_id == user.projekt_manager.id
      end
    end
  end
end
