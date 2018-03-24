# frozen_string_literal: true

require 'rspec/expectations'

describe ActionMailer::Base do
  describe 'add_delivery_method' do
    it 'should take an id, a base class and params' do
      expect do
        ActionMailer::Base.add_delivery_method(
          :id,
          FakeDeliveryMethod,
          arg1: true, arg2: false
        )
      end.to_not raise_error
    end
  end

  describe 'delivery_method=' do
    it 'should take an id' do
      ActionMailer::Base.add_delivery_method(
        :id,
        FakeDeliveryMethod,
        arg1: true, arg2: false
      )

      expect do
        ActionMailer::Base.delivery_method = :id
      end.to_not raise_error
    end
  end

  describe 'register_interceptor=' do
    it 'should take an object that responds to "delivering_email(message)"' do
      expect do
        ActionMailer::Base.register_interceptor FakeInterceptor.new
      end.to_not raise_error
    end
  end

  describe 'smtp_settings=' do
    it 'should take a hash' do
      expect { ActionMailer::Base.smtp_settings = {} }.to_not raise_error
    end
  end

  describe 'instance' do
    subject(:mailer) do
      class FakeActionMailer < ActionMailer::Base; end
      FakeActionMailer.send(:new)
    end

    describe 'attachments' do
      it 'should return an array-like object' do
        expect(mailer.attachments).to eq([])
      end
    end

    describe 'mail' do
      it 'should receive a hash and a block' do
        expect do
          mailer.mail(subject: 'none') { |format| format.text { '' } }
        end.to_not raise_error
      end
    end
  end
end

class FakeDeliveryMethod
  def initialize(hash); end
end

class FakeInterceptor
  def delivering_email(message); end
end
