console:
	TZ=/usr/share/zoneinfo/UTC bundle exec rails c

deploy:
	bundle exec cap staging deploy

worker:
	bundle exec sidekiq -e development -C ./config/sidekiq.yml

run:
	bundle exec rails s -p 8080

.PHONY: test
test:
	bin/rails test ./test/models/scheduler_test.rb
