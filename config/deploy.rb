require 'bundler/capistrano'

$:.unshift(File.expand_path("./lib", ENV["rvm_path"]))
require "rvm/capistrano"

set :stages, %w(production staging)
set :default_stage, 'staging'
require 'capistrano/ext/multistage'

set :rvm_ruby_string, '1.9.3'
set :rvm_type, :root

set :server, :unicorn

set :application, "gistflow"
set :repository,  "git@github.com:gistflow/gistflow.git"

set :scm, :git
set :branch, ENV['BRANCH'] || "master"
set :user, "git"

after "deploy:restart", "deploy:cleanup"

after "deploy:update_code", "db:link_configuration_file"
after "deploy:update_code", "settings:link_settings_file"

set(:shared_database_path) {"#{shared_path}/databases"}
set(:shared_config_path) { "#{shared_path}/config" }

namespace :db do
  desc "Links the configuration file"
  task :link_configuration_file do
    run "ln -nsf #{shared_config_path}/database.yml #{current_release}/config/database.yml"
  end
end

namespace :settings do
  desc "Links the settings file"
  task :link_settings_file do
    run "ln -nsf #{shared_config_path}/application.yml #{current_release}/config/application.yml"
  end
end

namespace :deploy do
  task :restart do
    run "cd #{current_release} && bundle exec god -c #{current_release}/config/god.rb"
    run "cd #{current_release} && bundle exec god restart unicorn"
  end
end
