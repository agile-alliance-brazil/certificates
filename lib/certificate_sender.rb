#encoding: UTF-8
require 'action_mailer'
require File.expand_path('./certificate_mailer.rb', File.dirname(__FILE__))

class CertificateSender
  attr_reader :sender, :subject, :content_type
  def initialize(configs, subject, content_type='application/pdf')
    @sender = "#{configs['user']}@#{configs['domain']}"
    ActionMailer::Base.smtp_settings = {
      :tls => true,
      :address => configs['smtp_server'],
      :port => configs['smtp_port'] || "587",
      :domain => configs['domain'],
      :authentication => :plain,
      :user_name => @sender,
      :password => configs['password']
    }
    @subject = subject
    @content_type = content_type
  end
  def send_certificate_to(attendee)
    @attendee = attendee
    CertificateMailer.deliver_certificate_to(self)
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
