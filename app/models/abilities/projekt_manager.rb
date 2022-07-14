module Abilities
  class ProjektManager
    include CanCan::Ability

    def initialize(user)
      merge Abilities::Common.new(user)

      can :edit, Projekt, projekt_manager_id: user.projekt_manager.id

      can(:manage, SiteCustomization::Page) do |c|
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
