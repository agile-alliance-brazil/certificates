# encoding:UTF-8
require_relative '../../spec_helper.rb'

describe CertificateModel do
  let(:svg) do
    File.read(
      File.expand_path(
        '../../fixtures/certificate.svg',
        File.dirname(__FILE__)
      )
    )
  end

  subject(:model) { CertificateModel.new(svg) }

  let(:attendee) { Attendee.new(name: 'Atendee One', email: 'fake@domain.com') }

  it 'should replace svg tag <name> with attendee name' do
    expect(model.svg_for(attendee)).to match(/Atendee One/i)
  end

  it 'should replace svg tag <email> with attendee email' do
    expect(model.svg_for(attendee)).to match(/fake@domain.com/i)
  end
end
