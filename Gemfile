#encoding: UTF-8
source 'https://rubygems.org'
ruby '2.2.2'

def linux_only(require_as)
  RbConfig::CONFIG['host_os'] =~ /linux/ ? require_as : false
end
# Mac OS X
def darwin_only(require_as)
  RbConfig::CONFIG['host_os'] =~ /darwin/ ? require_as : false
end

gem 'dotenv'
gem 'rake'
gem 'actionmailer', '4.2.3'
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
end

group :test do
  gem 'codeclimate-test-reporter', require: nil
end
