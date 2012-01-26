module Github
  module API
    URL = "https://api.github.com"
  
    def self.json(uri)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      request = Net::HTTP::Get.new(uri.request_uri)
      response = http.request(request).body
      ActiveSupport::JSON.decode(response)
    end
  end
end
