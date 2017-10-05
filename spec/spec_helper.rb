require 'simplecov'
SimpleCov.start

require 'certificator'
require 'certificator/decorators/identity'

Dir[File.expand_path('support/*.rb', File.dirname(__FILE__))].each do |file|
  require file
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"
end
