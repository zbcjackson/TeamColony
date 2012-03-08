set :stages, %w[staging production]
set :default_stage, 'staging'
require 'capistrano/ext/multistage'
set :application, "team-colony"
set :repository,  "zbcjackson@iagile.me:~/src/TeamColony"

set :scm, :git

set :deploy_to, "/var/www/#{application}"
set :user, "jackson"
set :runner, user
default_run_options[:pty] = true

$:.unshift(File.expand_path('./lib', ENV['rvm_path'])) # Add RVM's lib directory to the load path.
require "bundler/capistrano"
require "rvm/capistrano"															 
set :rvm_ruby_string, '1.9.2' # you probably have this already
set :rvm_type, :user # this is the money config, it defaults to :system


set :db_admin_user, "root"
set :db_admin_password, "root"
set :db_user, db_admin_user
set :db_password, db_admin_password
set :db_name, "teamcolony"

def database_exists?
  exists = false

  run "mysql --user=#{db_admin_user} --password=#{db_admin_password} --execute=\"show databases;\"" do |channel, stream, data|
    exists = exists || data.include?(db_name)
  end

  exists
end

def create_database
  create_sql = <<-SQL
    CREATE DATABASE #{db_name};
  SQL

  run "mysql --user=#{db_admin_user} --password=#{db_admin_password} --execute=\"#{create_sql}\""
end

def setup_database_permissions
  grant_sql = <<-SQL
    GRANT ALL PRIVILEGES ON #{db_name}.* TO #{db_user}@localhost IDENTIFIED BY '#{db_password}';
  SQL

  run "mysql --user=#{db_admin_user} --password=#{db_admin_password} --execute=\"#{grant_sql}\""
end

namespace :deploy do
  
  desc "Create database"
  task :configure_database, :roles => :db, :except => { :no_release => true } do
    if !database_exists?
      create_database
      #setup_database_permissions
    end
  end
  
  desc "Precompile"
  task :precompile, :roles => :app, :except => { :no_release => true } do
    run "cd #{release_path} && rake assets:precompile RAILS_ENV=#{rails_env}"
  end
  
  desc "Start TeamColony server"
  task :start, :roles => :app, :except => { :no_release => true } do
    run "sudo start #{application}"
  end
  
  desc "Stop TeamColony server"
  task :stop, :roles => :app, :except => { :no_release => true } do
    run "sudo stop #{application}"
  end
  
  desc "Restart TeamColony server"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "sudo restart #{application} || sudo start #{application}"
  end

  task :create_deploy_to_with_sudo, :roles => :app do
    run "sudo chown #{user}:#{user} #{deploy_to}"
  end
  
  task :write_upstart_script, :roles => :app do
    upstart_script = <<-UPSTART
description "#{application}"

start on started networking
stop on runlevel [!2345]

env TCHOME=#{release_path}
env TCLOGS=/var/log/#{application}
env TCUSER=#{runner}

respawn

pre-start script
    chdir $TCHOME
    mkdir $TCLOGS                             ||true
    chown $TCUSER:admin $TCLOGS               ||true
    chmod 0755 $TCLOGS                        ||true
end script

script
  cd $TCHOME
  exec su -s /bin/sh -c 'exec "$0" "$@"' $TCUSER -- /home/jackson/.rvm/bin/r192_unicorn_rails -c config/unicorn.rb -E #{rails_env} -d \
                        >> $TCLOGS/access.log \
                        2>> $TCLOGS/error.log
end script
UPSTART

    put upstart_script, "/tmp/#{application}_upstart.conf"
    run "sudo mv /tmp/#{application}_upstart.conf /etc/init/#{application}.conf"
  end
  
end

before 'deploy:setup', 'deploy:create_deploy_to_with_sudo'
after 'deploy:setup', 'deploy:configure_database'
after 'deploy:create_symlink', 'deploy:write_upstart_script'
after 'deploy:create_symlink', 'deploy:precompile'

namespace :rvm do
  task :trust_rvmrc do
    run "rvm rvmrc trust #{release_path}"
  end
	after "deploy", "rvm:trust_rvmrc"
end
