class Ability
  include CanCan::Ability

  def initialize(user)
    if user
      can(:access, :all) and return if user.admin?
      
    else
      can [:index], :posts
      can :show, :gists
      can :access, :searches
      can :show, :tags
    end
  end
end
