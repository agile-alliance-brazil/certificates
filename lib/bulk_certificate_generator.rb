#encoding: UTF-8
require_relative './models/mailed_certificate_factory.rb'
require_relative './certificate_generator.rb'
require_relative './workers/bulk_sender_worker.rb'
require_relative './models/csv_parser.rb'
require_relative './models/attendee.rb'

class BulkCertificateGenerator
  def initialize(svg, configuration)
    factory = MailedCertificateFactory.new(configuration.email_sender, configuration.email_subject, configuration.email_generic_body)
    generator = CertificateGenerator.new(configuration, svg)

    @processor = BulkSenderWorker.new(generator, factory, limit: 0, sleep_time: 0)
  end
  def perform(csv)
    parser = CSVParser.new(csv)
    attendees = parser.select{|row| row[0].blank?}.
      map{|row| Attendee.new([row[1], row[2]], row[3])}

    @processor.perform(attendees)
  end
  def error_messages
    @processor.error_messages
  end
end
