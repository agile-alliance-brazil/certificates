#encoding: UTF-8
require_relative '../../spec_helper.rb'

describe MailedCertificateFactory do
  subject{
    MailedCertificateFactory.new('fake@domain.com',
      "Subject\n=======\n\nThis is an email")
  }
  let(:attendee) { double('attendee') }
  let(:certificate) { double('certificate') }
  it 'should build certificate with given parameters' do
    expect(MailedCertificate).to(receive(:new).
      with('fake@domain.com', "Subject\n=======\n\nThis is an email", attendee, certificate)
    )

    subject.build_for(attendee, certificate)
  end
end
