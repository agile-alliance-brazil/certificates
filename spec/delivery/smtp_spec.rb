# encoding:UTF-8

describe Delivery::SMTP do
  let(:default_settings) do
    {
      address: 'mail.yourconf.org',
      port: '999',
      domain: 'yourconf.org',
      authentication: 'plain',
      user_name: 'your-user@yourconf.org',
      password: 'pass'
    }
  end

  describe 'missing password' do
    subject(:smtp) { Delivery::SMTP.new(default_settings.except(:password)) }

    it { should_not be_complete }

    describe 'error message' do
      it 'should complain about missing password' do
        expect(smtp.error_messages).to match('password')
      end

      it 'should suggest environment variable SMTP_PASSWORD' do
        expect(smtp.error_messages).to match('SMTP_PASSWORD')
      end
    end
  end

  describe 'missing user_name' do
    subject(:smtp) { Delivery::SMTP.new(default_settings.except(:user_name)) }

    it { should_not be_complete }

    describe 'error message' do
      it 'should complain about missing user' do
        expect(smtp.error_messages).to match('user_name')
      end

      it 'should suggest environment variable SMTP_USERNAME' do
        expect(smtp.error_messages).to match('SMTP_USERNAME')
      end
    end
  end

  describe 'missing domain' do
    subject(:smtp) { Delivery::SMTP.new(default_settings.except(:domain)) }

    it { should_not be_complete }

    describe 'error message' do
      it 'should complain about missing domain' do
        expect(smtp.error_messages).to match('domain')
      end

      it 'should suggest environment variable SENDER' do
        expect(smtp.error_messages).to match('SENDER')
      end
    end
  end

  describe 'missing address' do
    subject(:smtp) { Delivery::SMTP.new(default_settings.except(:address)) }

    it { should_not be_complete }

    describe 'error message' do
      it 'should complain about missing address' do
        expect(smtp.error_messages).to match('address')
      end

      it 'should suggest environment variable SMTP_SERVER' do
        expect(smtp.error_messages).to match('SMTP_SERVER')
      end
    end
  end

  describe 'complete' do
    subject(:smtp) { Delivery::SMTP.new(default_settings) }

    it { should be_complete }

    describe 'error message' do
      it 'should be nil' do
        expect(smtp.error_messages).to be_nil
      end
    end

    it 'should have id :smtp' do
      expect(smtp.id).to eq(:smtp)
    end

    describe 'to_hash' do
      it 'should match given settings' do
        expect(smtp.to_hash).to eq(default_settings)
      end
    end

    describe 'install_on' do
      it 'should add a delivery method and set it' do
        mailer = double('action mailer')
        expect(mailer).to receive(:smtp_settings=).with(subject.to_hash)
        expect(mailer).to receive(:delivery_method=).with(subject.id)

        smtp.install_on(mailer)
      end
    end
  end
end
