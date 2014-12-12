#encoding: UTF-8
require_relative '../../spec_helper.rb'

describe Delivery::AWS do
  describe 'missing key id' do
    subject { Delivery::AWS.new(nil, 'secret') }
    it { should_not be_complete }
    describe 'error message' do
      it 'should complain about missing key id' do
        expect(subject.error_messages).to match('access key ID')
      end
      it 'should suggest environment variable AWS_ACCESS_KEY_ID' do
        expect(subject.error_messages).to match('AWS_ACCESS_KEY_ID')
      end
    end
  end

  describe 'missing secret key' do
    subject { Delivery::AWS.new('key', nil) }
    it { should_not be_complete }
    describe 'error message' do
      it 'should complain about missing secret key' do
        expect(subject.error_messages).to match('secret access key')
      end
      it 'should suggest environment variable AWS_SECRET_ACCESS_KEY' do
        expect(subject.error_messages).to match('AWS_SECRET_ACCESS_KEY')
      end
    end
  end

  describe 'complete' do
    subject { Delivery::AWS.new('key', 'secret') }
    it { should be_complete }
    describe 'error message' do
      it 'should be nil' do
        expect(subject.error_messages).to be_nil
      end
    end
    it 'should have id :ses' do
      expect(subject.id).to eq(:ses)
    end
    describe 'to_hash' do
      it 'should include key id' do
        expect(subject.to_hash).to include(access_key_id: 'key')
      end
      it 'should include secret key' do
        expect(subject.to_hash).to include(secret_access_key: 'secret')
      end
      it 'should not include server if nil' do
        expect(subject.to_hash).to_not include(:server)
      end
      it 'should include server as value if given' do
        subject = Delivery::AWS.new('key', 'secret', 'server')
        expect(subject.to_hash).to include(server: 'server')
      end
    end
    describe 'install_on' do
      it 'should add a delivery method and set it' do
        mailer = double('action mailer')
        expect(mailer).to receive(:add_delivery_method).with(subject.id, AWS::SES::Base, subject.to_hash)
        expect(mailer).to receive(:delivery_method=).with(subject.id)
        
        subject.install_on(mailer)
      end
    end
  end
end
