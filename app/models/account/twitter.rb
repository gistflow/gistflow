class Account::Twitter < ActiveRecord::Base
  belongs_to :user
  
  validates :user, :token, :secret, :twitter_id, presence: true
  validates :user_id, uniqueness: { scope: :twitter_id }
  
  def self.create_by_omniauth(omniauth)
    omniauth = omniauth.to_hash.to_options
    find_by_twitter_id(omniauth[:uid]) || create! do |account|
      account.token      = omniauth[:token]
      account.secret     = omniauth[:secret]
      account.twitter_id = omniauth[:uid]
      yield(account) if block_given?
    end
  end
  
end
