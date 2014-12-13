#encoding: UTF-8
require_relative '../mailer/certificate_mailer.rb'

class BulkSenderWorker
  PROCESSING_INTERVAL = 5
  def initialize(generator, factory, options = {})
    @errors = []
    @generator = generator
    @factory = factory
    @options = options
  end
  def perform(attendees)
    @errors = []
    attendees.each do |attendee|
      begin
        certificate = @generator.generate_certificate_for(attendee)
        mailed_certificate = @factory.build_for(attendee, certificate)
        CertificateMailer.certificate_to(mailed_certificate).deliver
        sleep(PROCESSING_INTERVAL)
      rescue Exception => e
        STDERR.puts "Erro ao enviar certificado para \"#{attendee.name}\" <#{attendee.email}>."
        STDERR.puts "Exceção: #{$!}"
        STDERR.puts e.backtrace
        @errors << attendee
      end
    end
  end
  def error_messages
    unless @errors.empty?
      STDERR.puts "Falha ao enviar certificado para as seguintes pessoas:"
      STDERR.puts "Nome,Email"
      @errors.each do |attendee|
        STDERR.puts %Q{"#{attendee.name}","#{attendee.email}"}
      end
    end
  end
end
