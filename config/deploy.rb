set :rvm_ruby_string, '1.9.3@gistflow'
require "rvm/capistrano"

require 'bundler/capistrano'

set :application, "gistflow"
set :repository,  "git@github.com:gistflow/gistflow.git"

set :scm, :git

set :user, "gistflow"

role :web, "gistflow.com"
role :app, "gistflow.com"
role :db,  "gistflow.com", :primary => true

after "deploy:restart", "deploy:cleanup"

namespace :deploy do
  task :restart do
    run "cd #{current_release} && rvmsudo god restart unicorn"
  end
end

