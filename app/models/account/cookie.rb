class Account::Cookie < ActiveRecord::Base
  belongs_to :user
  
  validates :secret, :user, :presence => true
  validates :secret, :uniqueness => true
  
  def self.user_by_secret(secret)
    return if secret.blank?
    find_by_secret(secret).try(:user)
  end
  
  def generate_secret!
    self.secret ||= Digest::SHA1.hexdigest begin
      crazy = 1.upto(rand 10 ).map do
        "Quack"
      end.join('! ')
      "#{rand.to_s} #{crazy} !!!"
    end
  end
end