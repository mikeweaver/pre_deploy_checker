source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.11.1'
# Use sqlite3 as the database for Active Record
gem 'sqlite3'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

gem 'bootstrap-sass'
gem 'inline_styles_mailer'
gem 'nokogiri', '1.10.5'

group :test do
  gem 'webmock'
  gem 'fakefs', require: 'fakefs/safe'
  gem 'mutant-rspec', require: false
  gem 'timecop'
  gem 'coveralls', '~> 0.8.22'
  gem 'rspec'
  gem 'rspec-rails'
  gem 'database_cleaner'
  gem 'stub_env'
  gem 'brakeman', require: false
  gem 'rubocop', require: false
  gem 'rubocop-rspec', require: false
  gem 'bundler-audit', require: false
end

group :development do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  gem 'foreman'
end

group :production do
  gem 'unicorn'
end

gem 'git_lib', '1.1.0', git: 'https://github.com/Invoca/git_lib.git', ref: '1770e03ba5c39d5545bc614cc59eef32f7471290'
gem 'git_models', '1.1.0', git: 'https://github.com/Invoca/git_models.git', ref: '6041b229851a89570621f42c7d32f94208a99e5f'
gem 'hobo_fields'
gem 'delayed_job_active_record'
gem 'daemons'
gem 'jira-ruby', '0.1.17', require: 'jira'
gem 'pry'

source 'https://gem.fury.io/invoca'
gem 'invoca_secrets'
