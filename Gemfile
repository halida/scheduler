source "https://rubygems.org"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 8.0.1"
# The modern asset pipeline for Rails [https://github.com/rails/propshaft]
gem "propshaft"
# Use mysql as the database for Active Record
gem "mysql2", "~> 0.5"
# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"
# Bundle and transpile JavaScript [https://github.com/rails/jsbundling-rails]
gem "jsbundling-rails"
# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"
# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"
# Bundle and process CSS [https://github.com/rails/cssbundling-rails]
gem "cssbundling-rails"
# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Use the database-backed adapters for Rails.cache, Active Job, and Action Cable
gem "solid_cache"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Deploy this application anywhere as a Docker container [https://kamal-deploy.org]
gem "kamal", require: false

# Add HTTP asset caching/compression and X-Sendfile acceleration to Puma [https://github.com/basecamp/thruster/]
gem "thruster", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

# template
begin
  gem 'hamlit'

  # gem "haml-rails"
  # gem "html2haml"
  # rails haml:erb2haml
end

# ui helper
begin
  gem 'tabs_on_rails'
  gem 'will_paginate'
  gem 'will_paginate-bootstrap-style'
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

# form
begin
  gem 'simple_form'
  gem "nested_form"
end

# jobs
begin
  gem "solid_queue"
  gem "mission_control-jobs"
end

# library
begin
  # fix ruby 3.1: https://github.com/settingslogic/settingslogic/pull/23
  gem "settingslogic", git: "https://github.com/brlo/settingslogic.git"

  # for SchedulerApi
  gem "rest-client", require: false

  # gem 'sentry-raven'

  gem 'whenever', require: false
  # # version
  # gem 'paper_trail'

  # gem 'premailer-rails'

  # gem 'silencer', require: false
end

# for scheduler
begin
  gem 'cronex'
  gem 'parse-cron'
end

group :development, :test do
  gem 'dotenv'

  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"

  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem "brakeman", require: false

  # Omakase Ruby styling [https://github.com/rails/rubocop-rails-omakase/]
  gem "rubocop-rails-omakase", require: false
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver"
end
