class Ability
  include CanCan::Ability

  def initialize(user)
    if user
      can(:access, :all) and return if user.admin?
    else
      can :index, :home
      can :show, [:users, :posts, :tags]
      can [:show, :create], :searches
    end
  end
end
