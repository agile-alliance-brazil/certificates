# encoding:UTF-8
require_relative '../../spec_helper.rb'

describe ConfigurationError do
  it 'should give message back' do
    expect(ConfigurationError.new('message').message).to eq('message')
  end
end
