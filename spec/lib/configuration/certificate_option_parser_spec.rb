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
  it 'should provide certificates folder path on parse!' do
    options = subject.parse!([])
    expect(options).to include(:certificates_folder_path)
    expect(options[:certificates_folder_path]).to match('certificates')
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
end
