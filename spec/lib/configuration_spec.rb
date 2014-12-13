#encoding: UTF-8
require_relative '../spec_helper.rb'

describe Configuration do
  before do
    allow(File).to receive(:read).and_call_original
    allow(File).to receive(:read).with(match(/json/)).and_return("{}")
  end
  it 'should raise exception with no arguments' do
    expect{ Configuration.new([]) }.
      to raise_error(ConfigurationError, /csv-filename\.csv/)
  end
  it 'should raise exception with one argument' do
    expect{ Configuration.new(['csv']) }.
      to raise_error(ConfigurationError, /svg-model-filename\.svg/)
  end
  it 'should raise exception if no deliveries are complete' do
    expect(Delivery).to receive(:configure_deliveries).
      and_return([double(:'complete?' => false, error_messages: 'message')])
    
    expect{ Configuration.new(['csv', 'svg']) }.
      to raise_error(ConfigurationError, 'message')
  end
  describe 'valid' do
    subject{ Configuration.new(['csv', 'svg']) }
    it 'should return csv_filepath from arguments' do
      expect(subject.csv_filepath).to eq('csv')
    end
    it 'should return svg_filepath from arguments' do
      expect(subject.svg_filepath).to eq('svg')
    end
    it 'should return inkscape_path from environment' do
      allow(ENV).to receive(:[]).and_call_original
      allow(ENV).to receive(:[]).with('INKSCAPE_PATH').and_return(:path)

      expect(subject.inkscape_path).to eq(:path)
    end
    it 'should return sender from last delivery' do
      expect(Delivery).to receive(:configure_deliveries).
        and_return([
          double(:'complete?' => true, to_hash: {
            user_name: 'test@somewhere.com'
          })
        ])

      expect(subject.email_sender).to eq('test@somewhere.com')
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
