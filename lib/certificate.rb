#!/usr/bin/env ruby
#encoding: UTF-8
require 'rubygems'
require 'fileutils'
require_relative './certificates.rb'

configuration = nil
begin
  configuration = Configuration.new(ARGV)
rescue ConfigurationError => e
  puts e.message
  exit(1)
end

FileUtils.mkdir_p configuration.certificates_folder_path

configuration.delivery.install_on(ActionMailer::Base)

certificate_sender = CertificateSender.new(configuration)
processor = BulkSenderWorker.new(certificate_sender, limit: 0, sleep_time: 0)

csv_content = File.open(configuration.csv_filepath, 'r') {|f| f.read }
parser = CSVParser.new(csv_content)

Attendee.conference_name = configuration.certificate['event_short_name']
Attendee.svg_model = File.read(configuration.svg_filepath)
Attendee.certificate_folder_path = configuration.certificates_folder_path
Attendee.base_body = configuration.generic_email_body
Attendee.inkscape_path = configuration.inkscape_path

attendees = parser.select{|row| row[0].blank?}.
  map{|row| Attendee.new([row[1], row[2]], row[3])}

processor.perform(attendees)

puts processor.error_messages
