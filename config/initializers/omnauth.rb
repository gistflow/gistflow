Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, ENV['GITHUB_KEY'], ENV['GITHUB_SECRET'], scope: 'gist', client_options: { ssl: { ca_path: "/etc/ssl/certs" } }
  provider :twitter, ENV['TWITTER_KEY'], ENV['TWITTER_SECRET'], client_options: { ssl: { ca_path: "/etc/ssl/certs" } }
end