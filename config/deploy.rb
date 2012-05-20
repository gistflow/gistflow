require 'bundler/capistrano'

$:.unshift(File.expand_path("./lib", ENV["rvm_path"]))
require "rvm/capistrano"

set :rvm_ruby_string, '1.9.3'
set :rvm_type, :root
set :stage, 'uk'

set :use_sudo, true

set :server, :unicorn

set :application, "gistflow"
set :repository,  "git@github.com:gistflow/gistflow.git"

set :scm, :git

set :user, "git"

role :web, "37.188.125.88"
role :app, "37.188.125.88"
role :db,  "37.188.125.88", :primary => true

after "deploy:restart", "deploy:cleanup"

namespace :deploy do
  task :restart do
    run "cd #{current_release} && god -c #{current_release}/config/god.rb restart unicorn"
  end
end
