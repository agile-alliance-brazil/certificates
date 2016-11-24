# encoding:UTF-8
require_relative '../../spec_helper.rb'

describe Certificate do
  let(:decorator) { Decorators::EventPdfCertificate.new('name') }

  it 'should not have attachment if pdf is nil' do
    certificate = Certificate.new(FactoryGirl.build(:attendee), nil, decorator)

    expect(certificate.attachment?).to be_falsey
  end

  describe 'valid certificate' do
    subject(:certificate) do
      Certificate.new(FactoryGirl.build(:attendee), 'data', decorator)
    end

    it 'should have attachment' do
      expect(certificate.attachment?).to be_truthy
    end

    it 'should give pdf back as received' do
      expect(certificate.pdf).to eq('data')
    end

    it 'should provide filename via path_generator' do
      expect(certificate.filename).to eq('JohnDoe.pdf')
    end
  end
end
