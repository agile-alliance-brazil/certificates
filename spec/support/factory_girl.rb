# encoding: UTF-8

require 'factory_girl'

FactoryGirl.reset_configuration
FactoryGirl.register_strategy(:build, FactoryGirl::Strategy::Build)
FactoryGirl.find_definitions

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods

  config.before(:suite) do
    FactoryGirl.reload
  end
end
