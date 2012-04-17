$redis = if redis_url = ENV['REDISTOGO_URL']
  uri = URI.parse(redis_url)
  Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
else
  Redis.new
end
