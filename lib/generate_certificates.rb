#!/usr/bin/env ruby
#encoding: UTF-8
require 'rubygems'
require 'json'
require 'dotenv'
require 'action_mailer'
require_relative './certificates.rb'

def build_options_from(arguments)
  Dotenv.load
  data_folder = arguments.size > 0 ? arguments[0] : nil
  option_parser = CertificateOptionParser.new(data_folder || '.')
  options = option_parser.parse!(arguments)
  {
    filename_pattern: options[:filename_pattern],
    data_folder: data_folder,
    deliveries: {
      sender: ENV['SENDER'],
      dry_run: options[:dry_run],
      smtp: {
        address: ENV['SMTP_SERVER'],
        port: ENV['SMTP_PORT'] || '587',
        domain: ENV['SENDER'] && ENV['SENDER'].split('@').last,
        authentication: ENV['AUTHENTICATION'] || 'plain',
        user_name: ENV['SMTP_USERNAME'] || ENV['SENDER'],
        password: ENV['SMTP_PASSWORD']
      },
      aws: {
        access_key_id: ENV['AWS_ACCESS_KEY_ID'],
        secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
        server: ENV['AWS_SERVER']
      }
    },
    inkscape_path: ENV['INKSCAPE_PATH'],
    cache_folder_path: options[:cache_folder_path],
    help: option_parser.help
  }
end

options = build_options_from(ARGV)
begin
  configuration = Configuration.new(options)
  csv_content = File.read(configuration.csv_filepath)
  svg_content = File.read(configuration.svg_filepath)
  body_template = File.read(configuration.body_template_path)

  configuration.delivery.install_on(ActionMailer::Base)

  generator = CertificateGenerator.new(svg_content,
    configuration.inkscape_path, configuration.cache_folder_path,
    configuration.filename_pattern)

  processor = BulkSenderWorker.new(generator, configuration.email_sender,
    body_template, limit: 0, sleep_time: 0)

  parser = CSVParser.new(csv_content)
  attendees = parser.to_attributes.map.with_index do |attributes, idx|
    Attendee.new({ id: idx + 1 }.merge(attributes))
  end

  processor.perform(attendees)
  puts processor.error_messages
rescue ConfigurationError => e
  puts e.message
  exit(1)
end
