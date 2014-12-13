#!/usr/bin/env ruby
#encoding: UTF-8
require 'rubygems'
require 'json'
require 'dotenv'
require 'action_mailer'
require_relative './certificates.rb'

def safe_json_parse(path)
  JSON.parse(File.read(path))
end

def build_options_from(arguments)
  Dotenv.load
  option_parser = CertificateOptionParser.new
  options = option_parser.parse!(arguments)
  {
    csv_filepath: arguments.size > 0 ? arguments[0] : nil,
    svg_filepath: arguments.size > 1 ? arguments[1] : nil,
    deliveries: {
      dry_run: options[:dry_run],
      smtp: {path: options[:smtp_settings_path], password: ENV['SMTP_PASSWORD'], settings: safe_json_parse(options[:smtp_settings_path])},
      aws: {access_key_id: ENV['AWS_ACCESS_KEY_ID'], secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'], server: ENV['AWS_SERVER']}
    },
    inkscape_path: ENV['INKSCAPE_PATH'],
    certificate: safe_json_parse(options[:certificate_config_path]),
    cache_folder_path: options[:cache_folder_path],
    help: option_parser.help
  }
end

options = build_options_from(ARGV)
begin
  configuration = Configuration.new(options)
  csv_content = File.read(configuration.csv_filepath)
  svg_content = File.read(configuration.svg_filepath)
  
  configuration.delivery.install_on(ActionMailer::Base)

  bulk_generator = BulkCertificateGenerator.new(svg_content, configuration)
  bulk_generator.perform(csv_content)
  puts bulk_generator.error_messages
rescue ConfigurationError => e
  puts e.message
  exit(1)
end
