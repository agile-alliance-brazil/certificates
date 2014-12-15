#encoding: UTF-8
require_relative '../../spec_helper.rb'

describe CertificateMailer do
  subject{CertificateMailer.send(:new)}
  let(:sender){
    sender = double("Sender")
    allow(sender).to receive(:has_attachment?).and_return(true)
    allow(sender).to receive(:basename).and_return('myfile.txt')
    allow(sender).to receive(:certificate).and_return('certificate content')
    allow(sender).to receive(:recipient).and_return('recipient@domain.com')
    allow(sender).to receive(:sender).and_return('sender@otherdomain.com')
    allow(sender).to receive(:subject).and_return('Email Subject')
    allow(sender).to receive(:text).and_return('Email Body')
    allow(sender).to receive(:html).and_return('<p>Email Body</p>')
    sender
  }
  before do
    @previous = ActionMailer::Base.perform_deliveries
    ActionMailer::Base.perform_deliveries = false
  end
  after do
    ActionMailer::Base.perform_deliveries = @previous
  end
  it 'should inherit from ActionMailer::Base' do
    expect(subject).to be_a(ActionMailer::Base)
  end
  it 'should not add attachment if sender does not have one' do
    allow(sender).to receive(:has_attachment?).and_return(false)

    subject.certificate_to(sender)

    expect(subject.attachments).to be_empty
  end
  it 'should add attachment and content with filename base if sender has one' do
    subject.certificate_to(sender)

    expect(subject.attachments['myfile.txt']).to_not be_nil
    expect(subject.attachments['myfile.txt'].decoded).to eq('certificate content')
  end
  it 'should mail with parameters' do
    expect(subject).to receive(:mail).with(to: sender.recipient,
      from: sender.sender, subject: sender.subject)
    
    subject.certificate_to(sender)
  end
  it 'should add email body accordingly' do
    expect(subject).to receive(:render).with(plain: sender.text)
    expect(subject).to receive(:render).with(html: sender.html)
    
    subject.certificate_to(sender)
  end
end