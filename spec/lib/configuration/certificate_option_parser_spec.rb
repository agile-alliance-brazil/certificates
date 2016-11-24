# encoding:UTF-8
require_relative '../../spec_helper.rb'

describe CertificateOptionParser do
  it 'should provide dry run as false on parse! without --dry-run' do
    options = subject.parse!([])
    expect(options).to include(dry_run: false)
  end

  it 'should accept parse with other params' do
    options = subject.parse!(['data_folder'])
    expect(options).to include(dry_run: false)
  end

  it 'should provide dry run as true on parse! with --dry-run at end' do
    options = subject.parse!(['data_folder', '--dry-run'])
    expect(options).to include(dry_run: true)
  end

  it 'should provide filename pattern as given value' do
    options = subject.parse!(['data_folder', '--filename', 'PREFIX'])
    expect(options).to include(filename_pattern: 'PREFIX')
  end

  it 'should provide filename pattern as nil if none provided' do
    options = subject.parse!(['data_folder'])
    expect(options).to include(filename_pattern: nil)
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

    context 'with different data folder' do
      subject { CertificateOptionParser.new('data') }

      it 'should provide cache folder path as data/certificates with data' do
        options = subject.parse!([])
        expect(options).to include(:cache_folder_path)
        expect(options[:cache_folder_path]).to match('data/certificates')
      end
    end
  end
end
