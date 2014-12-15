#encoding: UTF-8
require_relative '../../spec_helper.rb'

describe Decorators::EventPdfCertificate do
  describe 'with prefix' do
    subject{ Decorators::EventPdfCertificate.new('short-') }
    it 'should decorate filename with prefix' do
      expect(subject.decorate('file')).to eq('short-file.pdf')
    end
    it 'should decorate remove spaces with event name' do
      expect(subject.decorate("  file\n\t lala")).to eq('short-filelala.pdf')
    end
  end
  describe 'without prefix' do
    subject{ Decorators::EventPdfCertificate.new(nil) }
    it 'should skip prefix if nil' do
      expect(subject.decorate('file')).to eq('file.pdf')
    end
    it 'should decorate remove spaces' do
      expect(subject.decorate("  file\n\t lala")).to eq('filelala.pdf')
    end
  end
end
