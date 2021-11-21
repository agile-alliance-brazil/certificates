# frozen_string_literal: true

source 'https://rubygems.org'
ruby '3.0.2'

def linux_only(require_as)
  RbConfig::CONFIG['host_os'].match?(/linux/) ? require_as : false
end

def darwin_only(require_as)
  RbConfig::CONFIG['host_os'].match?(/darwin/) ? require_as : false
end

gem 'actionmailer', '~> 6.0'
gem 'aws-ses', git: 'https://github.com/zebitex/aws-ses.git', ref: '78-sigv4-problem', require: 'aws/ses'
gem 'dotenv'
gem 'json', '>= 2.3.0'
gem 'prawn-svg', '>= 0.30.0'
gem 'rake'
gem 'redcarpet', '>= 3.5.1'

group :development, :test do
  gem 'byebug'
  gem 'factory_bot', '>= 6.2.0'
  gem 'guard'
  gem 'guard-rspec'
  gem 'guard-rubocop', '>= 1.5.0'
  gem 'pry'
  gem 'rb-fsevent', require: darwin_only('rb-fsevent')
  gem 'rb-inotify', require: linux_only('rb-inotify')
  gem 'rspec'
  gem 'rubocop', '>= 1.23.0'
  gem 'terminal-notifier-guard', require: darwin_only('terminal-notifier-guard')
end

group :test do
  gem 'codeclimate-test-reporter', '>= 1.0.8', require: nil
end
