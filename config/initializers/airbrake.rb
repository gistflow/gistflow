Airbrake.configure do |config|
  config.api_key = Configuration.airbrake.api_key
  config.host    = 'errbit.vm.evrone.ru'
  config.port    = 80
  config.secure  = config.port == 443
end
