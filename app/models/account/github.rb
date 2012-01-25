class Account::Github < ActiveRecord::Base
  def self.find_or_create_with_omniauth(omniauth)
    find_by_token omniauth['user_info']['nickname'] || create! do |account|
      account.github_id = omniauth['uid']
      account.build_user do |user|
        user_info, urls = omniauth['user_info'], user_info['urls']
        
        user.username = user_info['nickname']
        user.email = user_info['email']
        user.name = user_info['name']
        user.site_url = urls['Blog'] if urls
        user.gravatar_token = omniauth['extra']['raw_info']['gravatar_id'] rescue nil
      end
    end
  end
end
