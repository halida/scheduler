SET_ENV=dotenv -f .env.dev

console:
	$(SET_ENV) bundle exec rails console
dev:
	$(SET_ENV) bin/dev
server:
	$(SET_ENV) bin/rails s -p 3010

jobs:
	$(SET_ENV) bin/jobs start

# job=DailyReportJob make enqueue
enqueue:
	$(SET_ENV) bin/rake jobs:enqueue

whenever:
	whenever


# config=.env.deploy.staging make deploy
.ONESHELL:
deploy:
	export DEPLOY_REGISTRY_PASSWORD=`aws ecr get-login-password --profile docker`
	dotenv -f $(config) kamal deploy

# config=.env.deploy.staging make deploy_upload_config
.ONESHELL:
deploy_upload_config:
	dotenv -f $(config) -- sh -c 'echo $$CONFIG_FILE'
	dotenv -f $(config) -- sh -c 'scp $$CONFIG_FILE $$DEPLOY_USER@$$DEPLOY_SERVER:/tmp/'
	dotenv -f $(config) -- sh -c 'ssh $$DEPLOY_USER@$$DEPLOY_SERVER "sudo cp /tmp/application.yml /var/lib/docker/volumes/scheduler_storage/_data/"'


test_prepare:
	RAILS_ENV=test $(SET_ENV) bin/rake db:migrate

# file=./test/models/scheduler_test.rb make test
.PHONY: test
test:
	$(SET_ENV) bin/rails test $(file)

prepare_database:
	mysql <<-EOF
	create database scheduler_development;
	grant all privileges on scheduler_development.* to 'user'@'%';
	create database scheduler_development_cache;
	grant all privileges on scheduler_development_cache.* to 'user'@'%';
	create database scheduler_development_queue;
	grant all privileges on scheduler_development_queue.* to 'user'@'%';
	create database scheduler_test;
	grant all privileges on scheduler_test.* to 'user'@'%';
	EOF
	$(SET_ENV) bin/rake db:prepare
