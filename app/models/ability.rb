class Ability
  include CanCan::Ability

  def initialize(user)
    # simple authorization like self.current_user = User.first
    can :create, :sessions if development?
    
    can :show, :sitemap
    can [:index, :all, :leaderboard], :posts
    can :show, [:users, :posts, :tags, :gists]
    can [:show, :create, :empty], :searches
    can :create, :users
    can :not_found, :errors
    can :index, [:'users/followings', :'users/followers']
    can :show, :landings
    can [:history, :show], :'tags/wikis'    
    can :show, :maps
    can :cloud, :tags

    if user
      can(:access, :all) and return if user.admin?
      
      can :create, :markdown
      
      can [:edit, :update], :'tags/wikis'
      can [:create], :'account/twitter'
      can [:edit, :update], :'account/settings'
      can [:edit, :update], :'account/profiles'
      can :index, :'account/remembrances'
      can [:create, :destroy], [:'account/followings', :'account/observings', :'account/bookmarks']
      can :create, :'account/likes'
      can [:show, :update], [:'account/profiles', :'account/settings']
      can [:all, :flow, :following, :bookmarks], :posts
      can [:new, :create], :posts
      cannot :create, :like, :user_id => user.id
      can :destroy, :sessions
      can :create, :comments
      can [:edit, :update, :destroy], :comments, :user_id => user.id
      can [:preview, :build, :update, :create, :edit, :destroy], :'posts/comments'
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
