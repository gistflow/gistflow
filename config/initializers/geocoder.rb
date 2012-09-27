Geocoder.configure do |config|
  config.lookup = :google
  config.timeout = 5
  config.units = :km
end