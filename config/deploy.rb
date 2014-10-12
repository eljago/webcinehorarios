set :rbenv_type, :user # or :system, depends on your rbenv setup
set :rbenv_ruby, '2.1.2p95'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all # default value

set :whenever_identifier, ->{ "#{fetch(:application)}_#{fetch(:stage)}" }

set :application, 'webcinehorarios'
set :repo_url, 'ssh://perforce@107.170.169.97:1525/home/perforce/repos/webcinehorarios.git'

set :deploy_to, '/home/jago/apps/webcinehorarios'

set :linked_files, %w{config/database.yml config/application.yml config/secrets.yml}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/uploads}

set :default_env, { path: "~/.rbenv/shims:~/.rbenv/bin:$PATH" }

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, 'deploy:restart'
  after :finishing, 'deploy:cleanup'
  before :deploy, 'deploy:check_revision'
end