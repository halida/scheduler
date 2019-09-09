console:
	TZ=/usr/share/zoneinfo/UTC bundle exec rails c
server:
	TZ=/usr/share/zoneinfo/UTC bundle exec rails server -b 0.0.0.0 -p 3010

deploy:
	bundle exec cap staging deploy

worker:
	bundle exec sidekiq -e development -C ./config/sidekiq.yml

run:
	bundle exec rails s -p 8080

.PHONY: test
test:
	bin/rails test ./test/models/scheduler_test.rb
