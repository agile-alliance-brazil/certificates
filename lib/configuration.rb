#encoding: UTF-8
require 'optparse'
require 'dotenv'
require 'json'

class Configuration
  def initialize(arguments)
    Dotenv.load
    option_parser = CertificateOptionParser.new
    options = option_parser.parse!(arguments)

    raise option_parser.help if arguments.size < 2

    @csv_filepath = arguments[0]
    @svg_filepath = arguments[1]
    @dry_run = DryRunSettings.new if options[:dry_run]
    @smtp_settings = SMTPSettings.new(options[:smtp_settings_path])
    @smtp_settings.password = ENV['SMTP_PASSWORD']
    @aws_settings = AWSSettings.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY'], ENV['AWS_SERVER'])
    @certificate = parse_json_from(options[:certificate_config_path])

    raise delivery.error_messages unless delivery.complete?
  end
  def csv_filepath
    @csv_filepath
  end
  def svg_filepath
    @svg_filepath
  end
  def dry_run?
    !@dry_run.nil?
  end
  def aws_settings
    @aws_settings.to_hash
  end
  def smtp_settings
    @smtp_settings.to_hash
  end
  def inkscape_path
    ENV['INKSCAPE_PATH']
  end
  def certificate
    @certificate
  end
  def email_sender
    @smtp_settings.to_hash[:user_name]
  end
  def email_subject
    "Certificado de #{certificate['type']} da #{certificate['event']}"
  end
  def generic_email_body
    """Foi um grande prazer contar com sua presença na #{certificate['event']}.
Segue em anexo o seu certificado de #{certificate['type']}.
Esperamos encontrá-lo novamente na #{certificate['next_event']} em #{certificate['next_location']}.

Sinceramente,
Organização da #{certificate['event']}
"""
  end
  def certificates_folder_path
    File.expand_path("../certificates/", File.dirname(__FILE__))
  end
  def delivery
    if @dry_run
      @dry_run
    elsif @aws_settings.complete?
      @aws_settings
    else
      @smtp_settings
    end
  end
  private
  def parse_json_from(path)
    JSON.parse(File.read(path))
  end
end
