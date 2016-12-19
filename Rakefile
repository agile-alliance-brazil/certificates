# encoding:UTF-8
require 'rake'
require 'rspec/core/rake_task'

desc 'Run the specs.'
RSpec::Core::RakeTask.new do |t|
  t.pattern = 'spec/**/*_spec.rb'
end

namespace :test do
  task ci: %i(spec codeclimate-test-reporter)
end

task ci: :spec

task :'codeclimate-test-reporter' do
 sh 'if [[ -n ${CODECLIMATE_REPO_TOKEN} ]]; then\
   bundle exec codeclimate-test-reporter;\
   fi'
end

task default: :'test:ci'
