#encoding: UTF-8
require 'rake'
require 'rspec/core/rake_task'

desc 'Run the specs.'
RSpec::Core::RakeTask.new do |t|
  t.pattern = 'spec/**/*_spec.rb'
end

namespace :test do
  task ci: :spec
end

task default: :'test:ci'
