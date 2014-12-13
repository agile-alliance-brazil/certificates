#encoding: UTF-8
require_relative '../../spec_helper.rb'

describe PDFPathGenerator do
  let(:attendee) { Attendee.new(['a', 'cleaned', 'name'], ['fake@domain.com']) }
  subject{ PDFPathGenerator.new('/', IdentityDecorator.new) }
  it 'should provide basename with cleaned up attendee name' do
    expect(subject.basename_for(attendee)).to eq('ACleanedName.pdf')
  end
  it 'should expand path to given folder' do
    expect(subject.path_for(attendee)).to eq('/ACleanedName.pdf')
  end
end
