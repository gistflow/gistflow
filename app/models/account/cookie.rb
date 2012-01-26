class Account::Cookie < ActiveRecord::Base
  belongs_to :user
  
  validates :secret, :user, :presence => true
  validates :secret, :uniqueness => true
  
  def self.user_by_secret(secret)
    return if secret.blank?
    find_by_secret(secret).try(:user)
  end
end
