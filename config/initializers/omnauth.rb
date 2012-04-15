Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, ENV['GITHUB_KEY'], ENV['GITHUB_SECRET'], scope: 'gist'
  provider :twitter, ENV['TWITTER_KEY'], ENV['TWITTER_SECRET']
end