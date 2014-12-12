#encoding: UTF-8
require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

require_relative '../lib/certificates.rb'
Dir[File.expand_path('support/*.rb', File.dirname(__FILE__))].each do |file|
  require file
end
