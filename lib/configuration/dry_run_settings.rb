#encoding: UTF-8
require_relative './dry_run_interceptor.rb'

class DryRunSettings
  def initialize
  end
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
