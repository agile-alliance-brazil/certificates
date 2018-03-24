# frozen_string_literal: true

describe ConfigurationError do
  it 'should give message back' do
    expect(ConfigurationError.new('message').message).to eq('message')
  end
end
