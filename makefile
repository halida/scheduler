console:
	bundle exec rails console
dev:
	bin/dev
server:
	bin/rails s -p 3010

jobs:
	bin/jobs start

# job=DailyReportJob make enqueue
enqueue:
	bin/rake jobs:enqueue


# config=.env.deploy.staging make deploy
.ONESHELL:
deploy:
	export DEPLOY_REGISTRY_PASSWORD=`aws ecr get-login-password --profile docker`
	dotenv -f $(config) kamal deploy


test_prepare:
	RAILS_ENV=test bin/rake db:migrate

# file=./test/models/scheduler_test.rb make test
.PHONY: test
test:
	bin/rails test $(file)

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
	bin/rake db:prepare
