require_relative '../../spec_helper.rb'

describe MailedCertificate do
  let(:attendee) { double('attendee') }
  let(:certificate) { double('certificate') }
  subject(:mailed_certificate) do
    MailedCertificate.new(
      'sender@domain.com',
      %(Subject\n=======\n\nDear <%= attendee.name %>,\n
This is an email with a link to http://www.agilealliancebrazil.org.  \n\
With another line in the same paragraph.\n\nThanks!),
      attendee,
      certificate
    )
  end

  it 'should delegate attachment to certificate' do
    expect(certificate).to receive(:attachment?).and_return(true)

    expect(mailed_certificate.attachment?).to be_truthy
  end

  it 'should delegate basename to certificate' do
    expect(certificate).to receive(:filename).and_return('file.pdf')

    expect(mailed_certificate.basename).to eq('file.pdf')
  end

  it 'should delegate certificate to certificate' do
    expect(certificate).to receive(:pdf).and_return(:pdf)

    expect(mailed_certificate.certificate).to eq(:pdf)
  end

  it 'should delegate recipient to attendee' do
    expect(attendee).to receive(:email).and_return('fake@domain.com')

    expect(mailed_certificate.recipient).to eq('fake@domain.com')
  end

  it 'should return sender as given' do
    expect(mailed_certificate.sender).to eq('sender@domain.com')
  end

  it 'should return subject from bodys first line' do
    expect(attendee).to receive(:name).and_return('Hugo Corbucci')

    expect(mailed_certificate.subject).to eq('Subject')
  end

  it 'should return text as base body with attendees name' do
    expect(attendee).to receive(:name).and_return('Hugo Corbucci')

    text = mailed_certificate.text
    expect(text).to match('Dear Hugo Corbucci')
    expect(text).to match(%(This is an email with a link to \
http://www.agilealliancebrazil.org.  \nWith another line in the same \
paragraph.))
    expect(text).to match('Thanks!')
  end

  it 'should return html as tagged body with attendees name' do
    expect(attendee).to receive(:name).and_return('Hugo Corbucci')

    html = mailed_certificate.html
    expect(html).to match('<p>Dear Hugo Corbucci,</p>')
    expect(html).to match(%(<p>This is an email with a link to \
<a href="http://www.agilealliancebrazil.org">http://www.agilealliancebrazil.org\
</a>.<br>\nWith another line in the same paragraph.</p>))
    expect(html).to match('<p>Thanks!</p>')
  end
end
