require 'bundler/capistrano'

set :user, 'alex'
set :domain, '192.168.220.218'
set :application, 'depot'

set :rvm_type, :user
set :rvm_ruby_string, 'ruby-2.0.0-p247'
require "rvm/capistrano"

set :repository, "https://github.com/holyketzer/#{application}.git"
set :deploy_to, "/home/#{user}/rails/#{application}"

# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, domain                          # Your HTTP server, Apache/etc
role :app, domain                          # This may be the same as your `Web` server
role :db,  domain, :primary => true # This is where Rails migrations will run

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

set :deploy_via, :remote_cache
set :scm, 'git'
set :branch, 'master'
set :scm_verbose, true
set :use_sudo, false
set :normalize_asset_timestamps, false
set :rails_env, :production

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  # task :start do ; end
  # task :stop do ; end

  desc "cause Passenger to initiate a restart"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
    #run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  desc "reload the database with seed data"
  task :seed do
  	deploy.migrations
  	run "cd #{current_path}; rake db:seed RAILS_ENV=#{rails_env}"
	end
end