#encoding: UTF-8
require_relative '../../spec_helper.rb'

describe Attendee do
  it 'should build name with single name by itself' do
    subject = Attendee.new('hugo', 'fake@domain.com')

    expect(subject.name).to eq('Hugo')
  end
  it 'should build name with single name in an array' do
    subject = Attendee.new(['hugo'], 'fake@domain.com')

    expect(subject.name).to eq('Hugo')
  end
  it 'should build name with multiple names' do
    subject = Attendee.new(['hugo', 'corbucci'], 'fake@domain.com')

    expect(subject.name).to eq('Hugo Corbucci')
  end
  it 'should build name with multiple names with spaces' do
    subject = Attendee.new(['hugo  ', ' corbucci  '], 'fake@domain.com')

    expect(subject.name).to eq('Hugo Corbucci')
  end
  it 'should take email' do
    subject = Attendee.new(['hugo', 'corbucci'], 'fake@domain.com')

    expect(subject.email).to eq('fake@domain.com')
  end
end
