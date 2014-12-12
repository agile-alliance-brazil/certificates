#encoding: UTF-8
require 'json'

class Delivery::SMTP
  def initialize(path, password, content)
    @config_path = path
    @settings = content || {}
    @settings['password'] = password
  end
  def complete?
    !!(@settings['smtp_server'] &&
      @settings['user'] &&
      @settings['domain'] &&
      @settings['password'])
  end
  def id
    :smtp
  end
  def error_messages
    return nil if complete?

    message = "There are problems with your SMTP server configuration:\n"
    message += message_for('smtp_server', 'server')
    message += message_for('user')
    message += message_for('domain')
    message += "Missing SMTP password. Please define an environment variable with key name 'SMTP_PASSWORD' or add that entry to your .env file." unless @settings['password']
    message
  end
  def to_hash
    {
      address: @settings['smtp_server'],
      port: @settings['smtp_port'] || "587",
      domain: @settings['domain'],
      authentication: @settings['authentication'] || :login,
      user_name: "#{@settings['user']}@#{@settings['domain']}",
      password: @settings['password'],
    }
  end
  def install_on(action_mailer)
    action_mailer.smtp_settings = to_hash
    action_mailer.delivery_method = id
  end
  private
  def message_for(key, human_name = key)
    if @settings[key]
      ''
    else
      "Missing SMTP #{human_name}. Please ensure your json in #{config_path} has a key at the first level called '#{key}'.\n"
    end
  end
  def config_path
    @config_path
  end
end
