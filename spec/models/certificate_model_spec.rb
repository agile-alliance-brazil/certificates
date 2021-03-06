# frozen_string_literal: true

describe Certificator::CertificateModel do
  let(:svg) do
    File.read(
      File.expand_path(
        '../fixtures/certificate.svg',
        File.dirname(__FILE__)
      )
    )
  end

  subject(:model) { Certificator::CertificateModel.new(svg) }

  let(:attendee) do
    Certificator::Attendee.new(name: 'Atendee One', email: 'fake@domain.com')
  end

  it 'should replace svg tag <name> with attendee name' do
    expect(model.svg_for(attendee)).to match(/Atendee One/i)
  end

  it 'should replace svg tag <email> with attendee email' do
    expect(model.svg_for(attendee)).to match(/fake@domain.com/i)
  end

  context 'with weird characters' do
    let(:attendee) do
      Certificator::Attendee.new(name: 'Name & <others>', email: 'fake@d.com')
    end

    it 'should replace svg tag <name> with attendee name' do
      expect(model.svg_for(attendee)).to match(/Name &amp; &lt;others&gt;/i)
    end
  end
end
