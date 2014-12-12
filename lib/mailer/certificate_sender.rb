#encoding: UTF-8
require 'action_mailer'
require_relative './certificate_mailer.rb'

class CertificateSender
  attr_reader :sender, :subject, :content_type
  def initialize(configuration)
    @sender = configuration.email_sender
    @subject = configuration.email_subject
    @content_type = 'application/pdf'
  end
  def send_certificate_to(attendee)
    @attendee = attendee
    CertificateMailer.certificate_to(self).deliver
  end
  def recipient
    @attendee.email
  end
  def body
    @attendee.message
  end
  def has_attachment?
    not certificate.nil?
  end
  def certificate
    @attendee.certificate
  end
  def filename
    @attendee.filename
  end
  def message
    @attendee.message
  end
end
