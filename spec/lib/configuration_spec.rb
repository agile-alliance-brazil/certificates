#encoding: UTF-8
require_relative '../spec_helper.rb'

describe Configuration do
  let(:full_options) {
    {
      csv_filepath: '/path/to/csv-filename\.csv',
      svg_filepath: '/path/to/svg-model-filename\.svg',
      deliveries: {
        dry_run: false,
        smtp: {path: '/path/to/smtp.json', password: 'password', settings: {
          'user' => 'fake',
          'domain' => 'fake.com',
          'smtp_server' => 'smtp.fake.com'
        }},
        aws: {access_key_id: 'key', secret_access_key: 'secret', server: 'server'}
      },
      inkscape_path: '/path/to/inkscape',
      certificates: {
        'event' => 'Event Name 20xx',
        'event_short_name' => 'EN20xx',
        'next_event' => 'EN20xy',
        'next_location' => 'Knowhere',
        'type' => 'participant'
      },
      certificates_folder_path: '/path/to/certificates/',
      help: 'help!'
    }
  }
  it 'should raise exception with help message without csv filepath' do
    expect{ Configuration.new(full_options.except(:csv_filepath)) }.
      to raise_error(ConfigurationError, 'help!')
  end
  it 'should raise exception with help message without svg filepath' do
    expect{ Configuration.new(full_options.except(:svg_filepath)) }.
      to raise_error(ConfigurationError, 'help!')
  end
  it 'should raise exception if smtp deliveries are incomplete' do
    expect{ Configuration.new(full_options.merge({deliveries: {smtp: {}}})) }.
      to raise_error(ConfigurationError, /SMTP server configuration/)
  end
  describe 'valid' do
    subject{ Configuration.new(full_options) }
    it 'should return csv_filepath from arguments' do
      expect(subject.csv_filepath).to eq(full_options[:csv_filepath])
    end
    it 'should return svg_filepath from arguments' do
      expect(subject.svg_filepath).to eq(full_options[:svg_filepath])
    end
    it 'should return inkscape_path from environment' do
      expect(subject.inkscape_path).to eq(full_options[:inkscape_path])
    end
    it 'should return sender from last delivery' do
      expect(subject.email_sender).to eq('fake@fake.com')
    end
    it 'should return certificates folder path to certificates' do
      expect(subject.certificates_folder_path).to match('certificates')
    end
    it 'should return delivery as first one' do
      delivery = double(:'complete?' => true,
        to_hash: { user_name: 'test@somewhere.com' })
        
      expect(Delivery).to receive(:configure_deliveries).
        and_return([delivery])

      expect(subject.delivery).to eq(delivery)
    end
    it 'should provide certificate info'
    it 'should provide email subject'
    it 'should provide email generic body'
  end
end
