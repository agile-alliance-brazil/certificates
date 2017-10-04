# encoding:UTF-8
require 'certificator/delivery/dry_run'
require 'certificator/delivery/smtp'
require 'certificator/delivery/aws'

# Represents available delivery options to send certificate.
# Can be a dry-run (delivers to terminal), an AWS SES delivery
# or an SMTP delivery
module Delivery
  def self.configure_deliveries(config)
    deliveries = []
    deliveries << Delivery::DryRun.new if config[:dry_run]
    deliveries << build_aws(config[:aws]) if config[:aws]

    deliveries.select!(&:complete?)
    deliveries << Delivery::SMTP.new(config[:smtp])

    deliveries
  end

  private_class_method

  def self.build_aws(config)
    Delivery::AWS.new(
      config[:access_key_id],
      config[:secret_access_key],
      config[:server]
    )
  end
end
