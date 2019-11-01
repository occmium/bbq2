# config valid for current version and patch releases of Capistrano
lock "~> 3.11.2"

# Это имя приложения
# set :application, "capistr"
set :application, "bbq"

# Это url вашего репозитория, откуда Capistrano
# будет брать свежие версии исходников
# set :repo_url, "git@example.com:me/my_repo.git"
set :repo_url, "git@github.com:occmium/bbq2.git"

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# Папка, где будет храниться приложение
# set :deploy_to, '/home/deploy/apps/capistr'
set :deploy_to, '/home/deploy/apps/bbq'
# set :deploy_to, "/var/www/my_app_name"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true


# Файлы, которые лежат вне репозитория
# Default value for :linked_files is []
append :linked_files, "config/database.yml", "config/master.key", "config/credentials.yml.enc"
# append :linked_files, "config/database.yml"

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "vendor/bundle", "public/system", "public/uploads"

# после рестарта сервера (в конце деплоя) перезапустятся и воркеры
after 'deploy:restart', 'resque:restart'

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure

# If you want to restart using `touch tmp/restart.txt`, add this to your config/deploy.rb:
# set :passenger_restart_with_touch, true

# If you want to restart using `passenger-config restart-app`, add this to your config/deploy.rb:
# set :passenger_restart_with_touch, false # Note that `nil` is NOT the same as `false` here

# If you are installing passenger during your deployment AND you want to restart using `passenger-config restart-app`, you need to
# set :passenger_in_gemfile, true
