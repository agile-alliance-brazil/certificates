#encoding: UTF-8
require 'action_mailer'

class CertificateMailer < ActionMailer::Base
  def certificate_to(mailed_certificate)
    if mailed_certificate.has_attachment?
      attachments[mailed_certificate.basename] = mailed_certificate.certificate
    end

    mail(to: mailed_certificate.recipient, from: mailed_certificate.sender,
      subject: mailed_certificate.subject) do |format|
        # format.html { render html: mailed_certificate.html }
        format.text { render plain: mailed_certificate.text }
    end
  end
end
