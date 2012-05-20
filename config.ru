require 'rack'
require 'rack/cache'
require 'redis-rack-cache'
require 'rack/session/redis'

use Rack::Session::Redis
use Rack::Cache,
  :verbose     => true,
  :metastore   => 'redis://localhost:6379/0/metastore',
  :entitystore => 'redis://localhost:6379/0/entitystore'

require ::File.expand_path('../config/environment',  __FILE__)
require 'resque/server'

Resque::Server.use Rack::Auth::Basic do |username, password|
  password ==  ENV['RESQUE-AUTH_PASSWORD']
end

run Rack::URLMap.new \
  "/" => Gistflow::Application,
  "/resque" => Resque::Server.new
