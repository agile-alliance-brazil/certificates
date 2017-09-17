require 'simplecov'
SimpleCov.start

require_relative '../lib/certificates.rb'
require_relative '../lib/decorators/identity.rb'
Dir[File.expand_path('support/*.rb', File.dirname(__FILE__))].each do |file|
  require file
end
