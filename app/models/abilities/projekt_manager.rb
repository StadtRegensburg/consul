module Abilities
  class ProjektManager
    include CanCan::Ability

    def self.resources_to_manage
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

      can(:manage, ProjektManager.resources_to_manage) do |resource|
        resource.projekt.present? &&
        resource.projekt.projekt_manager_id == user.projekt_manager.id
      end

      can :moderate,    Proposal, projekt: { projekt_manager_id: user.projekt_manager.id }
      can :hide,        Proposal, hidden_at: nil, projekt: { projekt_manager_id: user.projekt_manager.id }
      can :ignore_flag, Proposal, ignored_flag_at: nil, hidden_at: nil,
        projekt: { projekt_manager_id: user.projekt_manager.id }

      can :comment_as_moderator, [Debate, Proposal], projekt: { projekt_manager_id: user.projekt_manager.id }
      # can :comment_as_moderator, Comment, hidden_at: nil

      can :manage, [Debate, Proposal], projekt: { projekt_manager_id: user.projekt_manager.id }

      # can :hide, Comment, hidden_at: nil

      # can :ignore_flag, Comment, ignored_flag_at: nil, hidden_at: nil
      # # cannot :ignore_flag, Comment, user_id: user.id

      # can :moderate, Comment
      # # cannot :moderate, Comment, user_id: user.id

      # can :hide, Debate, hidden_at: nil
      # cannot :hide, Debate, author_id: user.id

      # can :ignore_flag, Debate, ignored_flag_at: nil, hidden_at: nil
      # # cannot :ignore_flag, Debate, author_id: user.id

      # can :moderate, Debate
      # # cannot :moderate, Debate, author_id: user.id

      # can :hide, User
      # cannot :hide, User, id: user.id

      # can :block, User
      # cannot :block, User, id: user.id

      # can :hide, ProposalNotification, hidden_at: nil
      # cannot :hide, ProposalNotification, author_id: user.id

      # can :ignore_flag, ProposalNotification, ignored_at: nil, hidden_at: nil
      # # cannot :ignore_flag, ProposalNotification, author_id: user.id

      # can :moderate, ProposalNotification
      # # cannot :moderate, ProposalNotification, author_id: user.id

      # can :index, ProposalNotification

      # can :hide, Budget::Investment, hidden_at: nil
      # cannot :hide, Budget::Investment, author_id: user.id

      # can :ignore_flag, Budget::Investment, ignored_flag_at: nil, hidden_at: nil
      # # cannot :ignore_flag, Budget::Investment, author_id: user.id

      # can :moderate, Budget::Investment
      # # cannot :moderate, Budget::Investment, author_id: user.id
    end
  end
end
