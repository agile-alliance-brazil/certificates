#encoding: UTF-8
require_relative '../../spec_helper.rb'

describe CertificateModel do
  let(:svg) {
    File.read(
      File.expand_path(
        '../../fixtures/certificate.svg',
        File.dirname(__FILE__)
      )
    )
  }
  subject {CertificateModel.new(svg)}
  let(:attendee) { Attendee.new(['Hugo', 'Corbucci'], 'fake@domain.com') }
  it 'should replace svg tag <nome_do_participante> with attendee name' do
    expect(subject.svg_for(attendee)).to match(/Hugo Corbucci/i)
  end
end
