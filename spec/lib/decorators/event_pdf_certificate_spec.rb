#encoding: UTF-8
require_relative '../../spec_helper.rb'

describe Decorators::EventPdfCertificate do
  describe 'with short name' do
    subject{ Decorators::EventPdfCertificate.new('short') }
    it 'should decorate filename with event name' do
      expect(subject.decorate('file')).to eq('Certificado-short-file.pdf')
    end
    it 'should decorate remove spaces with event name' do
      expect(subject.decorate("  file\n\t lala")).to eq('Certificado-short-filelala.pdf')
    end
  end
  describe 'without short name' do
    subject{ Decorators::EventPdfCertificate.new(nil) }
    it 'should skip short name if nil' do
      expect(subject.decorate('file')).to eq('Certificado-file.pdf')
    end
    it 'should decorate remove spaces' do
      expect(subject.decorate("  file\n\t lala")).to eq('Certificado-filelala.pdf')
    end
  end
end
