# frozen_string_literal: true

require 'factory_bot'

FactoryBot.reset_configuration
FactoryBot.register_strategy(:build, FactoryBot::Strategy::Build)
FactoryBot.find_definitions

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods

  config.before(:suite) do
    FactoryBot.reload
  end
end
