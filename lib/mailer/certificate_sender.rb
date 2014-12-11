#encoding: UTF-8
require 'action_mailer'
require_relative './certificate_mailer.rb'

class CertificateSender
  attr_reader :sender, :subject, :content_type
  def initialize(configs, subject, content_type='application/pdf')
    @sender = "#{configs['user']}@#{configs['domain']}"
    ActionMailer::Base.smtp_settings = {
      address: configs['smtp_server'],
      port: configs['smtp_port'] || "587",
      domain: configs['domain'],
      authentication: :login,
      user_name: @sender,
      password: configs['password'],
    }
    @subject = subject
    @content_type = content_type
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
