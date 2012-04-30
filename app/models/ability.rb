class Ability
  include CanCan::Ability

  def initialize(user)
    # simple authorization like self.current_user = User.first
    can :create, :sessions if development?
    
    can :show, :sitemap
    can :index, :posts
    can :show, [:users, :posts, :tags, :gists]
    can [:show, :create], :searches
    can :create, :users
    
    if user
      can(:access, :all) and return if user.admin?
      can [:follow, :unfollow, :following, :followers], :users
      can [:all, :flow], :posts
      can [:new, :create, :memorize, :forgot, :like], :posts
      cannot :like, :posts, :user_id => user.id
      can :destroy, :sessions
      can :create, :comments
      can :index, [:'account/gists', :'account/notifications']
      can [:index, :create, :destroy], :'account/subscriptions'
      can [:edit, :update, :destroy], :posts, :user_id => user.id
    end
  end

protected
  
  def development?
    not Rails.env.production?
  end
end
