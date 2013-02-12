require 'bundler/capistrano'
require "rvm/capistrano"
require "capistrano-resque"

set :rvm_type, :system
set :rvm_ruby_string, '1.9.3-p327'

set :application, "gistflow"
set :rails_env, "production"
set :domain, "git@gistflow.com"
set :repository,  "git@github.com:gistflow/gistflow.git"
set :branch, "master"
set :use_sudo, false
set :deploy_to, "/u/apps/#{application}"
set :keep_releases, 3
set :normalize_asset_timestamps, false
set :scm, :git

role :app, domain
role :web, domain
role :db,  domain, :primary => true
role :resque_worker, domain

set :whenever_command, "bundle exec whenever"
require "whenever/capistrano"
require 'capistrano-unicorn'

after "deploy:restart", "resque:restart"

namespace :app do
  desc "Open the rails console on one of the remote servers"
  task :console, :roles => :app do
    exec %{ssh #{domain} -t "#{default_shell} -c 'cd #{current_path} && bundle exec rails c #{rails_env}'"}
  end

  desc "remote rake task"
  task :rake do
    run "cd #{deploy_to}/current; RAILS_ENV=#{rails_env} rake #{ENV['TASK']}"
  end
end

namespace :deploy do
  task :restart do
  end
  
  desc "Make symlinks"
  task :make_symlinks, :roles => :app, :except => { :no_release => true } do
    # db
    run "rm -f #{latest_release}/config/database.yml"
    run "ln -s #{deploy_to}/shared/config/database.yml #{latest_release}/config/database.yml"
    
    # settings
    run "rm -f #{latest_release}/config/application.yml"
    run "ln -s #{deploy_to}/shared/config/application.yml #{latest_release}/config/application.yml"
  end
  
  namespace :assets do
    task :precompile do
      from = source.next_revision(current_revision)
      if capture("cd #{latest_release} && #{source.local.log(from)} vendor/assets/ app/assets/ | wc -l").to_i > 0
        logger.info "Precompile assets."
        run "cd #{release_path} && bundle exec rake RAILS_ENV=#{rails_env} RAILS_GROUPS=assets assets:precompile"
      else
        logger.info "Skipping asset pre-compilation because there were no asset changes"
      end
    end
  end
end

after 'deploy:finalize_update', 'deploy:make_symlinks'