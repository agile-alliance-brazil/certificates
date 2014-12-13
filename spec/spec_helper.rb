#encoding: UTF-8
require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

require_relative '../lib/certificates.rb'
require_relative '../lib/decorators/identity.rb'
Dir[File.expand_path('support/*.rb', File.dirname(__FILE__))].each do |file|
  require file
end
