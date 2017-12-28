source 'https://rubygems.org'
ruby '2.4.3'

def linux_only(require_as)
  RbConfig::CONFIG['host_os'] =~ /linux/ ? require_as : false
end

def darwin_only(require_as)
  RbConfig::CONFIG['host_os'] =~ /darwin/ ? require_as : false
end

gem 'actionmailer', '~> 5.0'
gem 'aws-ses', require: 'aws/ses'
gem 'dotenv'
gem 'json'
gem 'prawn-svg'
gem 'rake'
gem 'redcarpet'

group :development, :test do
  gem 'byebug'
  gem 'factory_girl'
  gem 'guard'
  gem 'guard-rspec'
  gem 'guard-rubocop'
  gem 'pry'
  gem 'rb-fsevent', require: darwin_only('rb-fsevent')
  gem 'rb-inotify', require: linux_only('rb-inotify')
  gem 'rspec'
  gem 'rubocop'
  gem 'terminal-notifier-guard', require: darwin_only('terminal-notifier-guard')
end

group :test do
  gem 'codeclimate-test-reporter', require: nil
end
