#encoding: UTF-8
require_relative '../models/mailed_certificate.rb'
require_relative '../mailer/certificate_mailer.rb'

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
        certificate = @generator.generate_certificate_for(attendee)
        mailed_certificate = MailedCertificate.new(@sender, @body_template, attendee, certificate)
        CertificateMailer.certificate_to(mailed_certificate).deliver_now
        sleep(PROCESSING_INTERVAL)
      rescue Exception => e
        STDERR.puts "Erro ao enviar certificado para #{attendee.inspect}."
        STDERR.puts "Exceção: #{$!}"
        STDERR.puts e.backtrace
        @errors << attendee
      end
    end
  end
  def error_messages
    unless @errors.empty?
      STDERR.puts "Falha ao enviar certificado para as seguintes pessoas:"
      STDERR.puts @errors.first.attributes.keys.join(',')
      @errors.each do |attendee|
        STDERR.puts attendee.attributes.map{|k,v| v}.join(',')
      end
    end
  end
end
