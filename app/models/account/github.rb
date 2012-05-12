class Account::Github < ActiveRecord::Base
  belongs_to :user
  
  validates :token, :github_id, :user, :presence => true
  validates :token, :github_id, :uniqueness => true
  
  def self.find_or_create_by_omniauth(omniauth)
    token = omniauth['credentials']['token']
    ActiveRecord::Base.transaction do
      find_by_github_id(omniauth['uid']) || create! do |account|
        account.token     = token
        account.github_id = omniauth['uid']
        account.build_user do |user|
          info, urls = omniauth['info'], omniauth['info']['urls']
        
          user.username    = info['nickname']
          user.email       = info['email']
          user.name        = info['name'].blank? ? info['nickname'] : info['name']
          user.company     = omniauth['extra']['raw_info']['company']
          user.home_page   = urls['Blog']
          user.gravatar_id = omniauth['extra']['raw_info']['gravatar_id'] rescue nil
        end
      end
    end
  end
end
