# frozen_string_literal: true

require 'certificator/delivery/dry_run/dry_run_interceptor'

module Delivery
  # Represents a dry-run delivery mode which only prints to terminal
  class DryRun
    def initialize; end

    def complete?
      true
    end

    def error_messages
      nil
    end

    def to_hash
      {}
    end

    def id
      :test
    end

    def install_on(action_mailer)
      action_mailer.register_interceptor DryRunInterceptor.new
      action_mailer.delivery_method = id
    end
  end
end
