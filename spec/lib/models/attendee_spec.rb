# encoding:UTF-8
require_relative '../../spec_helper.rb'

describe Attendee do
  subject(:attendee) do
    Attendee.new(name: 'Hugo Corbucci', email: 'fake@domain.com')
  end

  it 'should build name with single name by itself' do
    expect(attendee.name).to eq('Hugo Corbucci')
  end

  it 'should take email' do
    expect(attendee.email).to eq('fake@domain.com')
  end
end
