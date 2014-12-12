#encoding: UTF-8
require_relative '../spec_helper.rb'

describe Delivery do
  describe 'configure_deliveries' do
    it 'should have dry_run as first option if dry_run is true' do
      deliveries = Delivery.configure_deliveries(
        dry_run: true,
        aws: {},
        smtp: {}
      )

      expect(deliveries.first).to be_instance_of(Delivery::DryRun)
    end
    it 'should have aws if dry_run is false but all AWS settings are available' do
      deliveries = Delivery.configure_deliveries(
        dry_run: false,
        aws: {access_key_id: 'id', secret_access_key: 'key'},
        smtp: {}
      )

      expect(deliveries.first).to be_instance_of(Delivery::AWS)
    end
    it 'should have smtp as last if dry_run is true' do
      deliveries = Delivery.configure_deliveries(
        dry_run: true,
        aws: {},
        smtp: {}
      )

      expect(deliveries.last).to be_instance_of(Delivery::SMTP)
    end
    it 'should have smtp as last if dry_run is false but AWS is complete' do
      deliveries = Delivery.configure_deliveries(
        dry_run: false,
        aws: {access_key_id: 'id', secret_access_key: 'key'},
        smtp: {}
      )

      expect(deliveries.last).to be_instance_of(Delivery::SMTP)
    end
    it 'should have smtp as last if dry_run is true and AWS is complete' do
      deliveries = Delivery.configure_deliveries(
        dry_run: true,
        aws: {access_key_id: 'id', secret_access_key: 'key'},
        smtp: {}
      )

      expect(deliveries.last).to be_instance_of(Delivery::SMTP)
    end
    it 'should have smtp if dry_run is false and AWS incomplete' do
      deliveries = Delivery.configure_deliveries(
        dry_run: false,
        aws: {},
        smtp: {}
      )

      expect(deliveries.first).to be_instance_of(Delivery::SMTP)
    end
    it 'should build AWS with access_key_id, secret_access_key and server' do
      expect(Delivery::AWS).to receive(:new).with('id', 'secret', 'server').and_call_original

      Delivery.configure_deliveries(
        dry_run: false,
        aws: {access_key_id: 'id', secret_access_key: 'secret', server: 'server'},
        smtp: {}
      )
    end
    it 'should build SMTP with access_key_id, secret_access_key and server' do
      expect(Delivery::SMTP).to receive(:new).with('path', 'pass', {}).and_call_original
      
      Delivery.configure_deliveries(
        dry_run: false,
        aws: {},
        smtp: {path: 'path', password: 'pass', settings: {}}
      )
    end
  end
end
