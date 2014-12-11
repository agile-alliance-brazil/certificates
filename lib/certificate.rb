#!/usr/bin/env ruby
#encoding: UTF-8
if ARGV.size < 2
  path = File.expand_path(__FILE__, File.dirname(__FILE__))
  puts "Usage: #{path} csv-filename.csv svg-model-filename.svg [--dry-run]"
  exit(1);
end

require 'rubygems'
require 'dotenv'
require 'json'
require 'fileutils'
Dotenv.load

require_relative './certificates.rb'


required_env_variables = ['INKSCAPE_PATH', 'EMAIL_PASSWORD']

env_path = File.expand_path('../.env', File.dirname(__FILE__))
unless File.exists?(env_path)
  puts "You are missing your .env file. Please create a file at #{env_path} with the following content:"
  required_env_variables.each do |variable|
    puts "#{variable}='VARIABLE_VALUE'"
  end
  exit(1);
end

missing_variables = required_env_variables.select{|variable| ENV[variable].nil?}
mail_configs = JSON.parse(File.read(File.expand_path('../config/smtp.json', File.dirname(__FILE__))))

dry_run = ARGV.size > 2 && ARGV[2]=="--dry-run"
if dry_run
  CertificateMailer.dry_run!
  missing_variables.reject{|variable| variable == 'PASSWORD'}
end

unless missing_variables.empty?
  puts "Your .env file is missing the following variables: #{missing_variables.join(", ")}"
  puts "Please add them before proceeding"
  exit(1);
end

INKSCAPE_PATH = ENV['INKSCAPE_PATH']
certificate = JSON.parse(File.read(File.expand_path('../config/certificate.json', File.dirname(__FILE__))))

SUBJECT = "Certificado de #{certificate['type']} da #{certificate['event']}"
BODY = """Foi um grande prazer contar com sua presença na #{certificate['event']}.
Segue em anexo o seu certificado de #{certificate['type']}.
Esperamos encontrá-lo novamente na #{certificate['next_event']} em #{certificate['next_location']}.

Sinceramente,
Organização da #{certificate['event']}
"""

CERTIFICATE_FOLDER_PATH = File.expand_path("../certificates/", File.dirname(__FILE__))
FileUtils.mkdir_p CERTIFICATE_FOLDER_PATH

mail_configs['password'] = ENV['PASSWORD'] unless dry_run
certificate_sender = CertificateSender.new(mail_configs, SUBJECT)
processor = BulkProcessor.new(certificate_sender, :limit => 0, :sleep_time => 0)

csv_filepath = ARGV[0]
csv_content = File.open(csv_filepath, 'r') {|f| f.read }
parser = CSVParser.new(csv_content)

Attendee.conference_name = certificate['event_short_name']
Attendee.svg_model = File.read(ARGV[1])
Attendee.certificate_folder_path = CERTIFICATE_FOLDER_PATH
Attendee.base_body = BODY
Attendee.inkscape_path = INKSCAPE_PATH

attendees = parser.select{|row| row[0].blank?}.
  map{|row| Attendee.new([row[1], row[2]], row[3])}

processor.process(attendees)

unless processor.failed_attendees.empty?
  STDERR.puts "Falha ao enviar certificado para as seguintes pessoas:"
  STDERR.puts "Nome,Email"
  processor.failed_attendees.each do |attendee|
    STDERR.puts %Q{"#{attendee.name}","#{attendee.email}"}
  end
end
