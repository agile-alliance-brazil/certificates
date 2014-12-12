#encoding: UTF-8
require_relative '../../spec_helper.rb'

describe Delivery::DryRun do  
  subject { Delivery::DryRun.new }
  it { should be_complete }
  describe 'error message' do
    it 'should be nil' do
      expect(subject.error_messages).to be_nil
    end
  end
  it 'should have id :test' do
    expect(subject.id).to eq(:test)
  end
  describe 'to_hash' do
    it 'should include be an empty hash' do
      expect(subject.to_hash).to eq({})
    end
  end
  describe 'install_on' do
    it 'should register an interceptor and set delivery method to :test' do
      mailer = double('action mailer')
      expect(mailer).to receive(:register_interceptor).with(instance_of(DryRunInterceptor))
      expect(mailer).to receive(:delivery_method=).with(subject.id)
      
      subject.install_on(mailer)
    end
  end
end
