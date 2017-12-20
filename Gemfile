source 'https://rubygems.org'

ruby "2.4.2"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1.2'

gem 'mysql2'

gem 'thin'

# template engines
begin
  gem 'sass-rails', '~> 5.0'
  gem 'coffee-rails', '~> 4.2'
  gem 'hamlit'
end

# stylesheet
begin
  gem 'bootstrap-sass', '~> 3.3.7'
  gem 'bootstrap-datepicker-rails'
  gem "font-awesome-rails"
end

# javascript
begin
  gem 'uglifier', '>= 1.3.0'
  gem 'jquery-rails'
  gem 'jquery-ui-rails'
  gem 'fancybox2-rails'
  gem "select2-rails"
end

# ui helper
begin
  gem 'tabs_on_rails'
  gem 'will_paginate'
  gem 'will_paginate-bootstrap'
  gem 'acts_as_list'
  gem 'nestive'
end

# auth
begin
  gem "rubycas-client"
  gem 'cancancan'

  gem 'devise'
  gem 'devise_cas_authenticatable'
end

# model
begin
  gem 'enumerize'
end

# form
begin
  gem 'simple_form'
  gem "nested_form"
end

# background job
begin
  gem 'redis-namespace'
  gem "redis-rails"
  gem 'sidekiq'
  # for sidekiq web
  gem 'sidekiq_status'
  # for sidekiq deployment
  # todo
  # gem 'sidekiq-client-cli', git: "https://github.com/halida/sidekiq-client-cli.git", branch: 'support-passing-job-arguments-per-job', require: false
end

# library
begin
  gem "settingslogic"
  gem "rest-client"

  gem 'airbrake'

  gem 'whenever', require: false
  # version
  gem 'paper_trail'
end

# for scheduler
begin
  gem 'cronex'
  gem 'parse-cron'
end


# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  # gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # Adds support for Capybara system testing and selenium driver
  # gem 'capybara', '~> 2.13'
  # gem 'selenium-webdriver'
end

group :development do
  gem 'pry'
  gem 'pry-rails'

  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'

  # deploy
  begin
    gem 'capistrano'
    gem 'capistrano-rvm'
    gem 'capistrano-bundler'
    gem 'capistrano-rails'
  end

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  # gem 'spring'
  # gem 'spring-watcher-listen', '~> 2.0.0'
end
