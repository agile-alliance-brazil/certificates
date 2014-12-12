#encoding: UTF-8
require 'aws/ses'

class AWSSettings
  def initialize(key_id, secret, server)
    @key_id = key_id
    @secret = secret
    @server = server
  end
  def complete?
    @key_id && @secret
  end
  def error_messages
    return nil if complete?

    message = "There are problems with your AWS configuration:\n"
    message += "Missing AWS access key ID. Please define an environment variable with key name 'AWS_ACCESS_KEY_ID' or add that entry to your .env file." unless @key_id
    message += "Missing AWS secret access key. Please define an environment variable with key name 'AWS_SECRET_ACCESS_KEY' or add that entry to your .env file." unless @secret
    message
  end
  def id
    :ses
  end
  def to_hash
    hash = {
      access_key_id: @key_id,
      secret_access_key: @secret
    }
    hash[:server] = @server if @server
    hash
  end
  def install_on(action_mailer)
    action_mailer.add_delivery_method id, AWS::SES::Base, to_hash
    action_mailer.delivery_method = id
  end
end
