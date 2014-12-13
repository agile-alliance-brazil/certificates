#encoding: UTF-8
require_relative '../spec_helper.rb'

require 'rspec/expectations'

describe ActionMailer::Base do
  describe 'add_delivery_method' do
    it 'should take an id, a base class and params' do
      expect{
        ActionMailer::Base.add_delivery_method(:id,
          FakeDeliveryMethod, {arg1: true, arg2: false})
      }.to_not raise_error
    end
  end

  describe 'delivery_method=' do
    it 'should take an id' do
      ActionMailer::Base.add_delivery_method(:id,
        FakeDeliveryMethod, {arg1: true, arg2: false})
      expect{
        ActionMailer::Base.delivery_method = :id
      }.to_not raise_error
    end
  end

  describe 'register_interceptor=' do
    it 'should take an object that responds to "delivering_email(message)"' do
      expect{
        ActionMailer::Base.register_interceptor FakeInterceptor.new
      }.to_not raise_error
    end
  end

  describe 'smtp_settings=' do
    it 'should take a hash' do
      expect{ ActionMailer::Base.smtp_settings=({}) }.to_not raise_error
    end
  end

  describe 'instance' do
    subject{
      class FakeActionMailer < ActionMailer::Base; end
      FakeActionMailer.send(:new)
    }
    describe 'attachments' do
      it 'should return an array-like object' do
        expect(subject.attachments).to eq([])
      end
    end
    describe 'mail' do
      it 'should receive a hash and a block' do
        expect{
          subject.mail({subject: 'none'}){|format| format.text{''}}
        }.to_not raise_error
      end
    end
  end
end

class FakeDeliveryMethod
  def initialize(hash)
  end
end

class FakeInterceptor
  def delivering_email(message)
  end
end
