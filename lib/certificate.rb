#!/usr/bin/env ruby
#encoding: UTF-8
require 'rubygems'
require 'fileutils'
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
    certificates_folder_path: options[:certificates_folder_path],
    help: option_parser.help
  }
end

options = build_options_from(ARGV)
begin
  configuration = Configuration.new(options)
  FileUtils.mkdir_p configuration.certificates_folder_path

  configuration.delivery.install_on(ActionMailer::Base)

  certificate_sender = CertificateSender.new(configuration)
  processor = BulkSenderWorker.new(certificate_sender, limit: 0, sleep_time: 0)

  csv_content = File.open(configuration.csv_filepath, 'r') {|f| f.read }
  parser = CSVParser.new(csv_content)

  Attendee.conference_name = configuration.certificate['event_short_name']
  Attendee.svg_model = File.read(configuration.svg_filepath)
  Attendee.certificate_folder_path = configuration.certificates_folder_path
  Attendee.base_body = configuration.email_generic_body
  Attendee.inkscape_path = configuration.inkscape_path

  attendees = parser.select{|row| row[0].blank?}.
    map{|row| Attendee.new([row[1], row[2]], row[3])}

  processor.perform(attendees)

  puts processor.error_messages
rescue ConfigurationError => e
  puts e.message
  exit(1)
end
