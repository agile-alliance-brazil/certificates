#encoding: UTF-8
require 'optparse'
require 'dotenv'
require 'json'
require_relative './configuration/configuration_error.rb'
require_relative './configuration/certificate_option_parser.rb'

class Configuration
  def initialize(arguments)
    Dotenv.load
    option_parser = CertificateOptionParser.new
    options = option_parser.parse!(arguments)

    @deliveries = Delivery.configure_deliveries(
      dry_run: options[:dry_run],
      smtp: {path: options[:smtp_settings_path], password: ENV['SMTP_PASSWORD'], settings: JSON.parse(File.read(options[:smtp_settings_path]))},
      aws: {access_key_id: ENV['AWS_ACCESS_KEY_ID'], secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'], server: ENV['AWS_SERVER']}
    )

    if arguments.size < 2
      raise ConfigurationError.new(option_parser.help)
    elsif !@deliveries.first.complete?
      raise ConfigurationError.new(@deliveries.first.error_messages)
    end

    @csv_filepath = arguments[0]
    @svg_filepath = arguments[1]
    @certificate = JSON.parse(File.read(options[:certificate_config_path]))
    @certificates_folder_path = options[:certificates_folder_path]
  end
  def csv_filepath
    @csv_filepath
  end
  def svg_filepath
    @svg_filepath
  end
  def inkscape_path
    ENV['INKSCAPE_PATH']
  end
  def certificate
    @certificate
  end
  def email_sender
    #TODO Get that some other way
    @deliveries.last.to_hash[:user_name]
  end
  def email_subject
    "Certificado de #{certificate['type']} da #{certificate['event']}"
  end
  def email_generic_body
    """Foi um grande prazer contar com sua presença na #{certificate['event']}.
Segue em anexo o seu certificado de #{certificate['type']}.
Esperamos encontrá-lo novamente na #{certificate['next_event']} em #{certificate['next_location']}.

Sinceramente,
Organização da #{certificate['event']}
"""
  end
  def certificates_folder_path
    @certificates_folder_path
  end
  def delivery
    @deliveries.first
  end
end
