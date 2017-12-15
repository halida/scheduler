class Ability
  include CanCan::Ability

  def initialize(user)
    @user = user
    if @user.present?
      can :manage, :all
    end
  end
  
end
