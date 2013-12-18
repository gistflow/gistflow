Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, Configuration.omniauth.github.key, Configuration.omniauth.github.secret, client_options: { ssl: { ca_path: "/etc/ssl/certs" } }
end
