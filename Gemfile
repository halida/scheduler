source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.2"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.0.4", ">= 7.0.4.3"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"

gem 'mysql2'

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 5.0"

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# Use Redis adapter to run Action Cable in production
gem "redis", "~> 4.0"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# template engines
begin
  gem 'sass-rails', '~> 5.0'
  gem 'coffee-rails', '~> 4.2'
  gem 'hamlit'
end

# stylesheet
begin
  gem 'bootstrap-sass'
  gem 'bootstrap-datepicker-rails'
  gem "font-awesome-rails"
end

# javascript
begin
  gem 'uglifier', '>= 1.3.0'
  gem 'magnific-popup-rails'
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
  gem 'openid_connect'
  gem 'omniauth_openid_connect'
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
  gem 'sidekiq', '~> 5.2.10'
  # for sidekiq deployment
  gem 'sidekiq-client-cli'
end

# library
begin
  # fix ruby 3.1: https://github.com/settingslogic/settingslogic/pull/23
  gem "settingslogic", git: "https://github.com/brlo/settingslogic.git"
  gem "rest-client"

  gem 'sentry-raven'

  gem 'whenever', require: false
  # version
  gem 'paper_trail'

  gem 'premailer-rails'

  # fix security issue
  gem "loofah", '>= 2.2.3'

  gem 'silencer', require: false
end

# for scheduler
begin
  gem 'cronex'
  gem 'parse-cron'
end


# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"

  # email debug
  gem 'letter_opener'

  # deploy
  begin
    gem 'capistrano'
    gem 'capistrano-rvm'
    gem 'capistrano-bundler'
    gem 'capistrano-rails'
    gem 'capistrano-sidekiq'
  end
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
end

gem 'rexml'

