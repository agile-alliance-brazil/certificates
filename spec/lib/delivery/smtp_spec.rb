#encoding: UTF-8
require_relative '../../spec_helper.rb'

describe Delivery::SMTP do
  let(:default_settings) {
    {
      'user' => 'your-user',
      'domain' => 'yourconf.org',
      'smtp_server' => 'mail.yourconf.org',
      'smtp_port' => '999',
      'authentication' => 'plain'
    }
  }
  describe 'missing password' do
    subject { Delivery::SMTP.new('path', nil, default_settings) }
    it { should_not be_complete }
    describe 'error message' do
      it 'should complain about missing password' do
        expect(subject.error_messages).to match('password')
      end
      it 'should suggest environment variable SMTP_PASSWORD' do
        expect(subject.error_messages).to match('SMTP_PASSWORD')
      end
    end
  end

  describe 'missing user' do
    subject { smtp = Delivery::SMTP.new('my_json_path', 'password', default_settings.except('user')) }
    it { should_not be_complete }
    describe 'error message' do
      it 'should complain about missing user' do
        expect(subject.error_messages).to match('user')
      end
      it 'should suggest json file in my_json_path' do
        expect(subject.error_messages).to match('my_json_path')
      end
    end
  end

  describe 'missing domain' do
    subject { smtp = Delivery::SMTP.new('my_json_path', 'password', default_settings.except('domain')) }
    it { should_not be_complete }
    describe 'error message' do
      it 'should complain about missing domain' do
        expect(subject.error_messages).to match('domain')
      end
      it 'should suggest json file in my_json_path' do
        expect(subject.error_messages).to match('my_json_path')
      end
    end
  end

  describe 'missing smtp_server' do
    subject { smtp = Delivery::SMTP.new('my_json_path', 'password', default_settings.except('smtp_server')) }
    it { should_not be_complete }
    describe 'error message' do
      it 'should complain about missing server' do
        expect(subject.error_messages).to match('server')
      end
      it 'should provide smtp_server key in message' do
        expect(subject.error_messages).to match('smtp_server')
      end
      it 'should suggest json file in my_json_path' do
        expect(subject.error_messages).to match('my_json_path')
      end
    end
  end

  describe 'complete' do
    subject { Delivery::SMTP.new('my_json_path', 'password', default_settings) }
    it { should be_complete }
    describe 'error message' do
      it 'should be nil' do
        expect(subject.error_messages).to be_nil
      end
    end
    it 'should have id :smtp' do
      expect(subject.id).to eq(:smtp)
    end
    describe 'to_hash' do
      it 'should include smtp_server as :address' do
        expect(subject.to_hash).to include(address: default_settings['smtp_server'])
      end
      it 'should include port' do
        expect(subject.to_hash).to include(port: default_settings['smtp_port'])
      end
      it 'should include default port (587) if none specified' do
        subject = Delivery::SMTP.new('my_json_path', 'password', default_settings.except('smtp_port'))
        expect(subject.to_hash).to include(port: '587')
      end
      it 'should include domain' do
        expect(subject.to_hash).to include(domain: default_settings['domain'])
      end
      it 'should include authentication' do
        expect(subject.to_hash).to include(authentication: default_settings['authentication'])
      end
      it 'should include default authentication (:login) if none specified' do
        subject = Delivery::SMTP.new('my_json_path', 'password', default_settings.except('authentication'))
        expect(subject.to_hash).to include(authentication: :login)
      end
      it 'should include user_name as user@domain' do
        expect(subject.to_hash).to include(user_name: "#{default_settings['user']}@#{default_settings['domain']}")
      end
      it 'should include password' do
        expect(subject.to_hash).to include(password: 'password')
      end
    end
    describe 'install_on' do
      it 'should add a delivery method and set it' do
        mailer = double('action mailer')
        expect(mailer).to receive(:smtp_settings=).with(subject.to_hash)
        expect(mailer).to receive(:delivery_method=).with(subject.id)
        
        subject.install_on(mailer)
      end
    end
  end
end
