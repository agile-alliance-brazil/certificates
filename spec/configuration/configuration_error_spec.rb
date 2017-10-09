# encoding:UTF-8

describe ConfigurationError do
  it 'should give message back' do
    expect(ConfigurationError.new('message').message).to eq('message')
  end
end
