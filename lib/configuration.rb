#encoding: UTF-8
require_relative './delivery.rb'
require_relative './configuration/configuration_error.rb'

class Configuration
  attr_reader :filename_pattern, :delivery, :email_sender, :csv_filepath,
    :svg_filepath, :body_template_path, :inkscape_path, :cache_folder_path

  def initialize(options)
    @filename_pattern = options[:filename_pattern]
    @delivery = Delivery.configure_deliveries(options[:deliveries]).first
    @email_sender = options[:deliveries][:sender]
    @csv_filepath = File.expand_path('data.csv', options[:data_folder])
    @svg_filepath = File.expand_path('model.svg', options[:data_folder])
    @body_template_path = File.expand_path('email.md.erb', options[:data_folder])
    @inkscape_path = options[:inkscape_path]
    @cache_folder_path = options[:cache_folder_path]

    raise_error_if_incomplete(options)
  end

  private

  def raise_error_if_incomplete(options)
    if options[:data_folder].nil?
      raise ConfigurationError.new(options[:help])
    elsif @email_sender.nil?
      raise ConfigurationError.new("Missing SENDER information. Please define an environment variable with key name 'SENDER' or add that entry to your .env file.")
    elsif !@delivery.complete?
      raise ConfigurationError.new(@delivery.error_messages)
    end
  end
end
