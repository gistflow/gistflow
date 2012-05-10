class Account::Github < ActiveRecord::Base
  belongs_to :user
  
  validates :token, :github_id, :user, :presence => true
  validates :token, :github_id, :uniqueness => true
  
  def self.find_or_create_by_omniauth(omniauth)
    token = omniauth['credentials']['token']
    ActiveRecord::Base.transaction do
      account = find_by_github_id(omniauth['uid']) || create! do |account|
        account.token     = token
        account.github_id = omniauth['uid']
        account.build_user do |user|
          info, urls = omniauth['info'], omniauth['info']['urls']
          extra = omniauth['extra']
        
          user.username    = info['nickname']
          user.name        = info['name'].blank? ? info['nickname'] : info['name']
          user.gravatar_id = omniauth['extra']['raw_info']['gravatar_id'] rescue nil
          user.build_profile do |profile|
            profile.company     = extra['raw_info']['company']
            profile.github_page = urls['GitHub']
            profile.home_page   = urls['Blog']
            profile.email       = info['email']
          end
        end  
      end
    end
  end
end
