class Ability
  include CanCan::Ability

  def initialize(user)
    if user
      can :manage, Pad
    end
  end
end