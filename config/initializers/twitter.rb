Twitter.configure do |config|
  config.consumer_key = Configuration.omniauth.twitter.key
  config.consumer_secret = Configuration.omniauth.twitter.secret
end