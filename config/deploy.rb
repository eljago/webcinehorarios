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
end