class Ability
  include CanCan::Ability

  def initialize(user)
    if user
      can :edit, EtherpadLite::Pad
    end
  end
end