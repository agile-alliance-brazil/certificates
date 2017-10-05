require 'simplecov'
SimpleCov.start

require 'certificator'
require 'certificator/decorators/identity'

Dir[File.expand_path('support/*.rb', File.dirname(__FILE__))].each do |file|
  require file
end
