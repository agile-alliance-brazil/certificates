# encoding:UTF-8

describe Certificator::Attendee do
  subject(:attendee) do
    Certificator::Attendee.new(name: 'Hugo Corbucci', email: 'fake@domain.com')
  end

  it 'should build name with single name by itself' do
    expect(attendee.name).to eq('Hugo Corbucci')
  end

  it 'should take email' do
    expect(attendee.email).to eq('fake@domain.com')
  end
end
