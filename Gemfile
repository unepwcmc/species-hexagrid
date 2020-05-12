source 'https://rubygems.org'

gem 'sinatra'
gem 'dotenv'
gem 'aws-sdk-resources'

group :development do
  gem 'capistrano', '~> 3.11.2', require: false
  gem 'capistrano-rvm',   '~> 0.1.2', require: false
  gem 'capistrano-passenger', '~> 0.1.1', require: false
  gem 'capistrano-bundler'
end

group :test, :development do
  gem 'byebug'
  gem 'rspec'
  gem 'rack-test'
  gem 'pry'
end


