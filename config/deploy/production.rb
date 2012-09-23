server 'gistflow.com', :app, :web, :db, :primary => true
set :deploy_env, 'production'

set :whenever_command, 'bundle exec whenever'
require 'whenever/capistrano'
