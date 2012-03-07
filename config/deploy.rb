set :application, "Team Colony"
set :repository,  "zbcjackson@iagile.me:~/src/TeamColony"

set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

set :deploy_to, "/var/www"
set :user, "jackson"
default_run_options[:pty] = true

role :web, "10.86.65.53"                          # Your HTTP server, Apache/etc
role :app, "10.86.65.53"                          # This may be the same as your `Web` server
role :db,  "10.86.65.53", :primary => true # This is where Rails migrations will run

require "bundler/capistrano"

$:.unshift(File.expand_path('./lib', ENV['rvm_path'])) # Add RVM's lib directory to the load path.
require "rvm/capistrano"                  # Load RVM's capistrano plugin.

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end