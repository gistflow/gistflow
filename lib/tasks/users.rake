require 'open-uri'

API_URL = 'https://api.github.com'

def fetch_address user
  JSON.parse(
    open("#{API_URL}/users/#{user.username}").read
  )['location']
end

namespace :users do
  task fetch_locations: :environment do
    User.all.each do |user|
      begin
        address = fetch_address user
        next if address.blank?

        user.create_location(address: address)
      rescue
        Rails.logger.info "No userinfo for #{user.username}"
      end
    end
  end
end