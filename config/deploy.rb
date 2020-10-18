# config valid for current version and patch releases of Capistrano
lock "~> 3.10.1"

set :rvm_ruby_version, '2.5.8'
set :rvm_type, :user

set :application, "scheduler"
set :repo_url, "https://github.com/halida/scheduler.git"

set :whenever_identifier, ->{ "#{fetch(:application)}_#{fetch(:stage)}" }

SSHKit.config.command_map[:runner] = "~/.rvm/bin/rvm #{fetch(:rvm_ruby_version)} do bundle exec rails r"

set :sidekiq_config, -> { File.join(shared_path, "config/sidekiq.yml") }
set :sidekiq_pid, -> { File.join(shared_path, 'tmp', 'sidekiq.pid') }

current_dir = File.expand_path(File.dirname(__FILE__))
app_path = File.dirname(current_dir)
settings = YAML.load_file(File.join(app_path, "config/deploy.yml"))[fetch(:stage).to_s]

role [:app, :web, :db], [settings['hostname']]
ssh_options = { forward_agent: true }
ssh_options[:proxy] = Net::SSH::Proxy::Command.new("ssh #{settings['ssh_proxy']} nc %h %p") if settings['ssh_proxy']
server settings['hostname'], user: settings['user'], roles: %w{web app db}, ssh_options: ssh_options
set :deploy_to, settings['path']

set :branch, 'openid'

set :linked_files, %w{config/application.yml config/database.yml config/thin.yml config/secrets.yml config/sidekiq.yml}

set :linked_dirs, %w{log tmp uploads}

set :keep_releases, 5


namespace :deploy do
  
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, "exec", "thin", "restart", "-C", "config/thin.yml"
        end
      end
    end
  end

  after :publishing, :restart

end

