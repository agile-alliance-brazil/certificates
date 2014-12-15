#encoding: UTF-8
require 'json'

class Delivery::SMTP
  def initialize(settings)
    @settings = settings
  end
  def complete?
    !!(@settings[:address] &&
      @settings[:user_name] &&
      @settings[:domain] &&
      @settings[:password])
  end
  def id
    :smtp
  end
  def error_messages
    return nil if complete?

    message = "There are problems with your SMTP server configuration:\n"
    message += message_for(:address, 'SMTP_SERVER')
    message += message_for(:user_name, 'SENDER')
    message += message_for(:domain, 'SENDER')
    message += message_for(:password, 'SMTP_PASSWORD')
    message
  end
  def to_hash
    @settings
  end
  def install_on(action_mailer)
    action_mailer.smtp_settings = to_hash
    action_mailer.delivery_method = id
  end
  private
  def message_for(key, environment_key)
    if @settings[key]
      ''
    else
      "Missing SMTP #{key}. Please define an environment variable with key name '#{environment_key}' or add that entry to your .env file.\n"
    end
  end
  def config_path
    @config_path
  end
end
