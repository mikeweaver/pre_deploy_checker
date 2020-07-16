source 'https://rubygems.org'

gem 'rails', '4.2.11.3'
gem 'sqlite3', '~> 1.3.0'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0', group: :doc

gem 'bootstrap-sass'
gem 'inline_styles_mailer'
gem 'nokogiri', '1.10.8'

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

gem 'git_lib', '~> 1.2'
gem 'git_models', '~> 1.2'
gem 'hobo_fields', '~> 3.0', git: 'git@github.com:Invoca/hobo_fields', ref: '8fe1e739b8d6a9d010b05cd7d97e509a17179fc5'
gem 'delayed_job_active_record'
gem 'daemons'
gem 'jira-ruby', '0.1.17', require: 'jira'
gem 'pry'

gem 'invoca_secrets', source: 'https://gem.fury.io/invoca'
