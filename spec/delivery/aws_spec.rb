# encoding:UTF-8

describe Delivery::AWS do
  describe 'missing key id' do
    subject(:aws) { Delivery::AWS.new(nil, 'secret') }

    it { should_not be_complete }

    describe 'error message' do
      it 'should complain about missing key id' do
        expect(aws.error_messages).to match('access key ID')
      end

      it 'should suggest environment variable AWS_ACCESS_KEY_ID' do
        expect(aws.error_messages).to match('AWS_ACCESS_KEY_ID')
      end
    end
  end

  describe 'missing secret key' do
    subject(:aws) { Delivery::AWS.new('key', nil) }

    it { should_not be_complete }

    describe 'error message' do
      it 'should complain about missing secret key' do
        expect(aws.error_messages).to match('secret access key')
      end
      it 'should suggest environment variable AWS_SECRET_ACCESS_KEY' do
        expect(aws.error_messages).to match('AWS_SECRET_ACCESS_KEY')
      end
    end
  end

  describe 'complete' do
    subject(:aws) { Delivery::AWS.new('key', 'secret') }

    it { should be_complete }

    describe 'error message' do
      it 'should be nil' do
        expect(aws.error_messages).to be_nil
      end
    end

    it 'should have id :ses' do
      expect(aws.id).to eq(:ses)
    end

    describe 'to_hash' do
      it 'should include key id' do
        expect(aws.to_hash).to include(access_key_id: 'key')
      end

      it 'should include secret key' do
        expect(aws.to_hash).to include(secret_access_key: 'secret')
      end

      it 'should not include server if nil' do
        expect(aws.to_hash).to_not include(:server)
      end

      it 'should include server as value if given' do
        aws = Delivery::AWS.new('key', 'secret', 'server')
        expect(aws.to_hash).to include(server: 'server')
      end
    end

    describe 'install_on' do
      it 'should add a delivery method and set it' do
        mailer = double('action mailer')
        expect(mailer).to receive(:add_delivery_method).with(
          aws.id,
          AWS::SES::Base,
          aws.to_hash
        )
        expect(mailer).to receive(:delivery_method=).with(aws.id)

        aws.install_on(mailer)
      end
    end
  end
end
