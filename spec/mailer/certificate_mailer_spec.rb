# frozen_string_literal: true

describe Certificator::CertificateMailer do
  subject(:mailer) { Certificator::CertificateMailer.send(:new) }

  let(:sender) do
    sender = double('Sender')
    allow(sender).to receive(:attachment?).and_return(true)
    allow(sender).to receive(:basename).and_return('myfile.txt')
    allow(sender).to receive(:certificate).and_return('certificate content')
    allow(sender).to receive(:recipient).and_return('recipient@domain.com')
    allow(sender).to receive(:sender).and_return('sender@otherdomain.com')
    allow(sender).to receive(:subject).and_return('Email Subject')
    allow(sender).to receive(:text).and_return('Email Body')
    allow(sender).to receive(:html).and_return('<p>Email Body</p>')
    sender
  end

  before do
    @previous = ActionMailer::Base.perform_deliveries
    ActionMailer::Base.perform_deliveries = false
  end

  after do
    ActionMailer::Base.perform_deliveries = @previous
  end

  it 'should inherit from ActionMailer::Base' do
    expect(mailer).to be_a(ActionMailer::Base)
  end

  it 'should not add attachment if sender does not have one' do
    allow(sender).to receive(:attachment?).and_return(false)

    mailer.certificate_to(sender)

    expect(mailer.attachments).to be_empty
  end

  it 'should add attachment and content with filename base if sender has one' do
    mailer.certificate_to(sender)

    expect(mailer.attachments['myfile.txt']).to_not be_nil
    expect(mailer.attachments['myfile.txt'].decoded).to eq(
      'certificate content'
    )
  end

  it 'should mail with parameters' do
    expect(mailer).to receive(:mail).with(
      to: sender.recipient,
      from: sender.sender,
      bcc: 'inscricoes@agilebrazil.com',
      subject: sender.subject
    )

    mailer.certificate_to(sender)
  end

  it 'should add email body accordingly' do
    expect(mailer).to receive(:render).with(plain: sender.text)
    expect(mailer).to receive(:render).with(html: sender.html)

    mailer.certificate_to(sender)
  end
end
