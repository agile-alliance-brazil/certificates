#encoding: UTF-8
require 'action_mailer'

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
end
