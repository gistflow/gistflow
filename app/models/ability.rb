class Ability
  include CanCan::Ability

  def initialize(user)
    # simple authorization like self.current_user = User.first
    can :create, :sessions if development?
    
    can :index, :home
    can :show, [:users, :posts, :tags]
    can [:show, :create], :searches
    
    if user
      can(:access, :all) and return if user.admin?
      can [:new, :create, :memorize, :forgot, :like], :posts
      cannot :like, :posts, :user_id => user.id
      can :destroy, :sessions
      can :index, [:'account/gists', :'account/notifications']
      can [:edit, :update, :destroy], :posts, :user_id => user.id
    end
  end

protected
  
  def development?
    not Rails.env.production?
  end
end
