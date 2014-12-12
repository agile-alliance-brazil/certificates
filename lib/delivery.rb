#encoding: UTF-8
module Delivery; end
require_relative 'delivery/aws.rb'
require_relative 'delivery/smtp.rb'
require_relative 'delivery/dry_run.rb'

module Delivery
  def self.configure_deliveries(config)
    deliveries = []
    deliveries << Delivery::DryRun.new if config[:dry_run]
    deliveries << Delivery::AWS.new(
      config[:aws][:access_key_id],
      config[:aws][:secret_access_key],
      config[:aws][:server])

    deliveries.select!{|delivery| delivery.complete?}
    deliveries << Delivery::SMTP.new(
      config[:smtp][:path],
      config[:smtp][:password],
      config[:smtp][:settings])

    deliveries
  end
end