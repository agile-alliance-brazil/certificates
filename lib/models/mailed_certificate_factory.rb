#encoding: UTF-8
require_relative './mailed_certificate.rb'

class MailedCertificateFactory
  def initialize(sender, subject, base_body)
    @sender = sender
    @subject = subject
    @base_body = base_body
  end
  def build_for(attendee, certificate)
    MailedCertificate.new(@sender, @subject, @base_body, attendee, certificate)
  end
end
