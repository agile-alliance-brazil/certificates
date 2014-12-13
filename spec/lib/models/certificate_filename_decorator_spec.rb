#encoding: UTF-8
require_relative '../../spec_helper.rb'

describe CertificateFilenameDecorator do
  describe 'with short name' do
    subject{ CertificateFilenameDecorator.new('short') }
    it 'should decorate filename with short name' do
      expect(subject.decorate('file')).to eq('Certificado-short-file')
    end
  end
  describe 'without short name' do
    subject{ CertificateFilenameDecorator.new(nil) }
    it 'should skip short name if nil' do
      expect(subject.decorate('file')).to eq('Certificado-file')
    end
  end
end
