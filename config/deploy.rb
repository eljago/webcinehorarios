require "rvm/capistrano"
require "bundler/capistrano"
require 'capistrano-db-tasks'

set :whenever_command, "bundle exec whenever"
require "whenever/capistrano"

set :default_environment, { 
  'PATH' => "/home/jago/.rvm/gems/ruby-2.1.2/bin:/home/jago/.rvm/gems/ruby-2.1.2@global/bin:/home/jago/.rvm/rubies/ruby-2.1.2/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/home/jago/.rvm/bin:/home/jago/.rvm/bin",
  'RUBY_VERSION' => 'ruby 2.1.2p95',
  'GEM_HOME' => "/home/jago/.rvm/gems/ruby-2.1.2",
  'GEM_PATH' => "/home/jago/.rvm/gems/ruby-2.1.2:/home/jago/.rvm/gems/ruby-2.1.2@global" 
}

## CAPISTRANO DB TASKS
# if you haven't already specified
set :rails_env, "production"
# if you want to remove the dump file after loading
set :db_local_clean, true
# if you want to work on a specific local environment (default = ENV['RAILS_ENV'] || 'development')
set :locals_rails_env, "development"

# Require the recipes you need, comment out the ones you don't

server "192.81.211.220", :web, :app, :db, primary: true

set :port, 1525
set :application, "webcinehorarios"
set :user, "jago"
set :deploy_to, "/home/#{user}/apps/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false

set :scm, "git"
set :repository, "ssh://perforce@107.170.169.97:1525/home/perforce/repos/#{application}.git"
set :branch, "master"

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

after "deploy", "deploy:cleanup" # keep only the last 5 releases
after "deploy", "deploy:migrate"

namespace :deploy do
  task :start do; end
  task :stop do; end
  task :restart, roles: :app, except: {no_release: true} do
    run "touch #{deploy_to}/current/tmp/restart.txt"
  end

  task :setup_config, roles: :app do
    run "mkdir -p #{shared_path}/config"
    run "mkdir -p #{shared_path}/uploads"
    put File.read("config/database.example.yml"), "#{shared_path}/config/database.yml"
    puts "Now edit the config files in #{shared_path}."
  end
  after "deploy:setup", "deploy:setup_config"

  task :symlink_config, roles: :app do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/assets #{release_path}/public/assets"
    run "ln -nfs #{shared_path}/uploads #{release_path}/public/uploads"
    run "ln -nfs #{shared_path}/config/application.yml #{release_path}/config/application.yml"
  end
  after "deploy:finalize_update", "deploy:symlink_config"

  desc "Make sure local git is in sync with remote."
  task :check_revision, roles: :web do
    unless `git rev-parse HEAD` == `git rev-parse origin/master`
      puts "WARNING: HEAD is not the same as origin/master"
      puts "Run `git push` to sync changes."
      exit
    end
  end
  before "deploy", "deploy:check_revision"
end

desc "tail log files"
task :tail, roles: :app do
  run "tail -f #{shared_path}/log/#{rails_env}.log" do |channel, stream, data|
    puts "#{channel[:host]}: #{data}"
    break if stream == :err
  end
end

desc "update manifest file"
task :manifest, roles: :app do
  run "cp #{shared_path}/assets/manifest.yml ~/."
  run "mv #{shared_path}/assets/manifest.yml #{shared_path}/../current/assets_manifest.yml"
end