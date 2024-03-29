# frozen_string_literal: true

require 'certificator/models/mailed_certificate'
require 'certificator/mailer/certificate_mailer'

module Certificator
  # Worker that handles generating certificate for all attendees
  # Eventually should support enqueuing the work instead of performing it
  class BulkSenderWorker
    PROCESSING_INTERVAL = 1

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
        deliver_certificate_for(attendee)
        sleep(PROCESSING_INTERVAL)
      rescue StandardError => e
        log_error(e, attendee)
        @errors << attendee
      end
    end

    def error_messages
      return if @errors.empty?

      messages = "Falha ao enviar certificado para as seguintes pessoas:\n"
      messages += "#{@errors.first.attributes.keys.join(',')}\n"
      @errors.each do |attendee|
        messages += "#{attendee.attributes.map { |_, v| v }.join(',')}\n"
      end
      messages
    end

    private

    def deliver_certificate_for(attendee)
      certificate = @generator.generate_certificate_for(attendee)
      return if attendee.email.nil? || !attendee.email.strip.size.positive?

      mailed_certificate = mailed_certificate_for(attendee, certificate)
      mail = Certificator::CertificateMailer.certificate_to(mailed_certificate)
      mail.deliver_now
    end

    def mailed_certificate_for(attendee, certificate)
      Certificator::MailedCertificate.new(
        @sender,
        @body_template,
        attendee,
        certificate
      )
    end

    def log_error(err, attendee)
      warn "Erro ao enviar certificado para #{attendee.inspect}."
      warn "Exceção: #{err.message}"
      warn err.backtrace
    end
  end
end
