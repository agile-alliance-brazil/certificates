# encoding:UTF-8
require_relative '../models/mailed_certificate.rb'
require_relative '../mailer/certificate_mailer.rb'

# Worker that handles generating certificate for all attendees
# Eventually should support enqueuing the work instead of performing it
class BulkSenderWorker
  PROCESSING_INTERVAL = 5

  def initialize(generator, sender, body_template, options = {})
    @errors = []
    @generator = generator
    @sender = sender
    @body_template = body_template
    @options = options
  end

  def perform(attendees)
    @errors = []
    attendees.each do |attendee|
      begin
        deliver_certificate_for(attendee)
        sleep(PROCESSING_INTERVAL)
      rescue StandardError => e
        log_error(e, attendee)
        @errors << attendee
      end
    end
  end

  def error_messages
    return if @errors.empty?

    STDERR.puts 'Falha ao enviar certificado para as seguintes pessoas:'
    STDERR.puts @errors.first.attributes.keys.join(',')
    @errors.each do |attendee|
      STDERR.puts attendee.attributes.map { |_, v| v }.join(',')
    end
  end

  private

  def deliver_certificate_for(attendee)
    certificate = @generator.generate_certificate_for(attendee)
    mailed_certificate = mailed_certificate_for(attendee, certificate)

    CertificateMailer.certificate_to(mailed_certificate).deliver_now
  end

  def mailed_certificate_for(attendee, certificate)
    MailedCertificate.new(@sender, @body_template, attendee, certificate)
  end

  def log_error(e, attendee)
    STDERR.puts "Erro ao enviar certificado para #{attendee.inspect}."
    STDERR.puts "Exceção: #{e.message}"
    STDERR.puts e.backtrace
  end
end
