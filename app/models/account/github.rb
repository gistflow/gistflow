class Account::Github < ActiveRecord::Base
  API_URL = "https://api.github.com"
  
  belongs_to :user
  
  def get_gists
    uri = URI.parse("#{API_URL}/users/#{self.user.username}/gists")
    get_data(uri)
  end
  
  private 
  
  def get_data(uri)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(uri.request_uri)
    response = http.request(request).body
    ActiveSupport::JSON.decode(response)
  end
end
