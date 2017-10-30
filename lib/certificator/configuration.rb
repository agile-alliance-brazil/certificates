require 'certificator/delivery'
require 'certificator/configuration/configuration_error'

module Certificator
  # Represents configuration to run the application
  class Configuration
    attr_reader :filename_pattern, :delivery, :email_sender, :csv_filepath,
                :svg_filepath, :body_template_path, :inkscape_path,
                :cache_folder_path

    def initialize(options)
      @filename_pattern = options[:filename_pattern]
      @delivery = Delivery.configure_deliveries(options[:deliveries]).first
      @email_sender = options[:deliveries][:sender]
      initialize_paths_from(options)

      raise_error_if_incomplete(options)
    end

    def font_paths
      Dir.glob("#{@data_folder}/*.{ttf,TTF}")
    end

    private

    def initialize_paths_from(options)
      @data_folder = options[:data_folder]
      @csv_filepath = File.expand_path('data.csv', options[:data_folder])
      @svg_filepath = File.expand_path('model.svg', options[:data_folder])
      body_path = File.expand_path('email.md.erb', options[:data_folder])
      @body_template_path = body_path
      @inkscape_path = options[:inkscape_path]
      @cache_folder_path = options[:cache_folder_path]
    end

    def raise_error_if_incomplete(options)
      error_class = ConfigurationError
      raise error_class, options[:help] if options[:data_folder].nil?
      if @email_sender.nil?
        raise error_class, "Missing SENDER information. Please define an \
  environment variable with key name 'SENDER' or add that entry to your .env \
  file."
      end
      raise error_class, @delivery.error_messages unless @delivery.complete?
    end
  end
end
