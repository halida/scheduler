console:
	bundle exec rails c

.PHONY: test
test:
	bin/rails test ./test/models/scheduler_test.rb
