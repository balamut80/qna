# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'qna'
set :repo_url, 'git@github.com:balamut80/qna.git'

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/home/deplayer/qna'
set :deployer_user, 'deplayer'

# Default value for :linked_files is []
set :linked_files, %w{config/database.yml config/private_pub.yml config/private_pub_thin.yml .env}

# Default value for linked_dirs is []
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/uploads}

set :default_shell, '/bin/bash -l'


namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
      invoke 'unicorn:restart'
    end
  end

  after :publishing, :restart
end

set :private_pub_pid, -> { "#{current_path}/tmp/pids/thin.pid" }

namespace :private_pub do
  desc 'Start private_pub server'
  task :start do
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, "exec thin -C config/private_pub_thin.yml -d -P #{fetch(:private_pub_pid)} start"
        end
      end
    end
  end

  desc 'Stop private_pub server'
  task :stop do
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute "if [ -f #{fetch(:private_pub_pid)} ] && [ -e /proc/$(cat #{fetch(:private_pub_pid)}) ]; then kill -9 `cat #{fetch(:private_pub_pid)}`; fi"
        end
      end
    end
  end

  desc 'Restart private_pub server'
  task :restart do
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          invoke 'private_pub:stop'
          invoke 'private_pub:start'
        end
      end
    end
  end
end

after 'deploy:restart', 'private_pub:restart'
