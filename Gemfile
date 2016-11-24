# encoding:UTF-8
source 'https://rubygems.org'
ruby '2.3.1'

def linux_only(require_as)
  RbConfig::CONFIG['host_os'] =~ /linux/ ? require_as : false
end

def darwin_only(require_as)
  RbConfig::CONFIG['host_os'] =~ /darwin/ ? require_as : false
end

gem 'dotenv'
gem 'rake'
gem 'actionmailer', '~> 5.0'
gem 'json'
gem 'aws-ses', require: 'aws/ses'
gem 'redcarpet'
gem 'prawn-svg'

group :development, :test do
  gem 'rspec'
  gem 'guard'
  gem 'guard-rspec'
  gem 'byebug'
  gem 'pry'
  gem 'rb-fsevent', require: darwin_only('rb-fsevent')
  gem 'terminal-notifier-guard', require: darwin_only('terminal-notifier-guard')
  gem 'rb-inotify', require: linux_only('rb-inotify')
  gem 'factory_girl'
  gem 'rubocop'
  gem 'guard-rubocop'
end

group :test do
  gem 'codeclimate-test-reporter', require: nil
end
