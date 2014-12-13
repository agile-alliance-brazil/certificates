#encoding: UTF-8
require_relative '../../spec_helper.rb'

describe CertificateOptionParser do
  it 'should provide certificate config path on parse!' do
    options = subject.parse!([])
    expect(options).to include(:certificate_config_path)
    expect(options[:certificate_config_path]).to match('config/certificate.json')
  end
  it 'should provide smtp settings path on parse!' do
    options = subject.parse!([])
    expect(options).to include(:smtp_settings_path)
    expect(options[:smtp_settings_path]).to match('config/smtp.json')
  end
  it 'should provide dry run as false on parse! without --dry-run' do
    options = subject.parse!([])
    expect(options).to include(dry_run: false)
  end
  it 'should accept parse with other params' do
    options = subject.parse!(['csv', 'svg'])
    expect(options).to include(dry_run: false)
  end
  it 'should provide dry run as true on parse! with after other params --dry-run' do
    options = subject.parse!(['csv', 'svg', '--dry-run'])
    expect(options).to include(dry_run: true)
  end
  describe 'cache folder path' do
    it 'should provide cache folder path on parse!' do
      options = subject.parse!([])
      expect(options).to include(:cache_folder_path)
      expect(options[:cache_folder_path]).to match('certificates')
    end
    it 'should provide cache folder path as nil if --no-cache' do
      options = subject.parse!(['--no-cache'])
      expect(options).to include(:cache_folder_path)
      expect(options[:cache_folder_path]).to be_nil
    end
    it 'should provide cache folder path as nil if --cache but no path' do
      options = subject.parse!(['--cache'])
      expect(options).to include(:cache_folder_path)
      expect(options[:cache_folder_path]).to match('certificates')
    end
    it 'should provide cache folder path as path if --cache with path' do
      options = subject.parse!(['--cache', 'path'])
      expect(options).to include(:cache_folder_path)
      expect(options[:cache_folder_path]).to match('path')
    end
  end
end
