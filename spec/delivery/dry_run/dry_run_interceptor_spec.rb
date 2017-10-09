# encoding:UTF-8
require 'stringio'

describe DryRunInterceptor do
  let(:fake_sender) { 'sender@fake.com' }
  let(:fake_recipient) { 'recipient@fake.com' }
  let(:fake_subject) { 'Fake subject' }
  let(:fake_body_text_content) { 'Fake plain text body content' }
  let(:fake_body_html_content) { '<p>Fake plain text body content</p>' }
  let(:fake_filename) { 'filename.txt' }
  let(:fake_attachment_content) { 'Fake attachment content' }
  let(:pdf_content_type) { 'application/pdf' }
  let(:fake_message) do
    message = double('message')
    allow(message).to receive(:from).and_return([fake_sender])
    allow(message).to receive(:to).and_return([fake_recipient])
    allow(message).to receive(:subject).and_return(fake_subject)
    allow(message).to receive(:text_part).and_return(fake_body_text_content)
    allow(message).to receive(:html_part).and_return(fake_body_html_content)
    allow(message).to receive(:has_attachments?).and_return(true)
    allow(message).to receive(:attachments).and_return(
      [
        double(
          filename: fake_filename,
          content: fake_attachment_content,
          content_type: pdf_content_type
        )
      ]
    )
    allow(message).to receive(:perform_deliveries=).with(false)
    message
  end
  let(:output) { StringIO.new }
  let(:interceptor) { DryRunInterceptor.new(output) }

  it 'should stop messages from being sent' do
    expect(fake_message).to receive(:perform_deliveries=).with(false)

    interceptor.delivering_email(fake_message)
  end

  it 'should log sender' do
    interceptor.delivering_email(fake_message)

    expect(output.string).to match(fake_sender)
  end

  it 'should log recipient' do
    interceptor.delivering_email(fake_message)

    expect(output.string).to match(fake_recipient)
  end

  it 'should log subject' do
    interceptor.delivering_email(fake_message)

    expect(output.string).to match(fake_subject)
  end

  it 'should log text body' do
    interceptor.delivering_email(fake_message)

    expect(output.string).to match(fake_body_text_content)
  end

  it 'should log html body' do
    interceptor.delivering_email(fake_message)

    expect(output.string).to match(fake_body_html_content)
  end

  it 'should log attachment file name' do
    interceptor.delivering_email(fake_message)

    expect(output.string).to match(fake_filename)
  end

  it 'should log attachment content type' do
    interceptor.delivering_email(fake_message)

    expect(output.string).to match(pdf_content_type)
  end

  it 'should log multiple attachments if more than one' do
    allow(fake_message).to receive(:attachments).and_return(
      [
        double(filename: fake_filename,
               content: fake_attachment_content,
               content_type: 'application/pdf'),
        double(filename: 'another_name.txt',
               content: fake_attachment_content,
               content_type: 'text/plain')
      ]
    )

    interceptor.delivering_email(fake_message)

    expect(output.string).to match('2 arquivo')
    expect(output.string).to match(fake_filename)
    expect(output.string).to match('another_name.txt')
  end
end
