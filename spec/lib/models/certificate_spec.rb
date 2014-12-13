#encoding: UTF-8
require_relative '../../spec_helper.rb'

describe Certificate do
  let(:decorator) { Decorators::EventPdfCertificate.new }
  it 'should not have attachment if pdf is nil' do
    certificator = Certificate.new(FactoryGirl.build(:attendee), nil, decorator)

    expect(certificator).to_not have_attachment
  end
  describe 'valid certificate' do
    subject { Certificate.new(FactoryGirl.build(:attendee), 'data', decorator) }
    it { should have_attachment }
    it 'should give pdf back as received' do
      expect(subject.pdf).to eq('data')
    end
    it 'should provide filename via path_generator' do
      expect(subject.filename).to eq('Certificado-JohnDoe.pdf')
    end
  end
end
