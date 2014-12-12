#encoding: UTF-8
module Delivery; end
require_relative 'delivery/aws.rb'
require_relative 'delivery/smtp.rb'
require_relative 'delivery/dry_run.rb'

module Delivery
  def self.configure_deliveries(config)
    deliveries = []
    deliveries << Delivery::DryRun.new if config[:dry_run]
    deliveries << build_aws(config[:aws])

    deliveries.select!{|delivery| delivery.complete?}
    deliveries << build_smtp(config[:smtp])

    deliveries
  end
  private
  def self.build_aws(config)
    Delivery::AWS.new(config[:access_key_id],
      config[:secret_access_key], config[:server])
  end
  def self.build_smtp(config)
    Delivery::SMTP.new(config[:path], config[:password], config[:settings])
  end
end
