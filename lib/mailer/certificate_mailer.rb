#encoding: UTF-8
require 'action_mailer'
require_relative './dry_run_interceptor.rb'

class CertificateMailer < ActionMailer::Base
  def certificate_to(sender)
    if sender.has_attachment?
      attachments[File.basename(sender.filename)] = sender.certificate
    end

    mail(to: sender.recipient, from: sender.sender,
      subject: sender.subject) do |format|
       format.text { render plain: sender.message }
    end
  end
  def self.dry_run!
    Mail.register_interceptor DryRunInterceptor
  end
end
