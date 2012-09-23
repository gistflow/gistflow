FactoryGirl.define do
  factory :account_token, :class => 'Account::Token' do
    user
    token { Digest::SHA1.hexdigest(rand.to_s) }
  end
end
