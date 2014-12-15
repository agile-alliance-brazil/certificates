#encoding: UTF-8
require_relative '../spec_helper.rb'

describe Configuration do
  let(:deliveries) {
    {
      sender: 'fake@fake.com',
      dry_run: false,
      smtp: {
        address: 'smtp.fake.com',
        port: '587',
        domain: 'fake.com',
        authentication: 'plain',
        user_name: 'fake@fake.com',
        password: 'password'
      },
      aws: {
        access_key_id: 'key',
        secret_access_key: 'secret',
        server: 'server'
      }
    }
  }
  let(:full_options) {
    {
      filename_prefix: 'Prefix-',
      data_folder: '/path/to/data-folder',
      deliveries: deliveries,
      inkscape_path: '/path/to/inkscape',
      cache_folder_path: '/path/to/certificates/',
      help: 'help!'
    }
  }
  it 'should raise exception with help message without data_folder' do
    expect{ Configuration.new(full_options.except(:data_folder)) }.
      to raise_error(ConfigurationError, 'help!')
  end
  it 'should raise exception if smtp deliveries are incomplete' do
    expect{ Configuration.new(full_options.merge(
      deliveries: {
        sender: 'fake@fake.com',
        dry_run: false, smtp: {}
      }
    )) }.to raise_error(ConfigurationError, /SMTP server configuration/)
  end
  it 'should raise exception if deliveries sender is not present' do
    expect{ Configuration.new(full_options.merge(deliveries: deliveries.except(:sender))) }.
      to raise_error(ConfigurationError, /SENDER information/)
  end
  describe 'valid' do
    subject{ Configuration.new(full_options) }
    it 'should return csv_filepath as data.csv inside data_folder' do
      expect(subject.csv_filepath).to eq(File.join(full_options[:data_folder], 'data.csv'))
    end
    it 'should return svg_filepath as model.svg inside data_folder' do
      expect(subject.svg_filepath).to eq(File.join(full_options[:data_folder], 'model.svg'))
    end
    it 'should return body_template_path as email.md.erb inside data_folder' do
      expect(subject.body_template_path).to eq(File.join(full_options[:data_folder], 'email.md.erb'))
    end
    it 'should return inkscape_path as given' do
      expect(subject.inkscape_path).to eq(full_options[:inkscape_path])
    end
    it 'should return sender as given' do
      expect(subject.email_sender).to eq('fake@fake.com')
    end
    it 'should return cache folder path to certificates' do
      expect(subject.cache_folder_path).to match('certificates')
    end
    it 'should return filename_prefix as given' do
      expect(subject.filename_prefix).to eq(full_options[:filename_prefix])
    end
    it 'should return delivery as first one' do
      delivery = double(:'complete?' => true,
        to_hash: { user_name: 'test@somewhere.com' })
        
      expect(Delivery).to receive(:configure_deliveries).
        and_return([delivery])

      expect(subject.delivery).to eq(delivery)
    end
  end
end
