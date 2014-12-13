#encoding: UTF-8
require_relative './configuration/configuration_error.rb'
require_relative './delivery.rb'

class Configuration
  def initialize(options)
    @deliveries = Delivery.configure_deliveries(options[:deliveries])
    @csv_filepath = options[:csv_filepath]
    @svg_filepath = options[:svg_filepath]
    @inkscape_path = options[:inkscape_path]
    @certificate = options[:certificate]
    @cache_folder_path = options[:cache_folder_path]

    if @csv_filepath.nil? || svg_filepath.nil?
      raise ConfigurationError.new(options[:help])
    elsif !@deliveries.first.complete?
      raise ConfigurationError.new(@deliveries.first.error_messages)
    end
  end
  def csv_filepath
    @csv_filepath
  end
  def svg_filepath
    @svg_filepath
  end
  def inkscape_path
    @inkscape_path
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
  def cache_folder_path
    @cache_folder_path
  end
  def delivery
    @deliveries.first
  end
end
