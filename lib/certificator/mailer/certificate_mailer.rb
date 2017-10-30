require 'action_controller'
require 'action_mailer'

module Certificator
  # A mailer that sends a mailed_certificate with both HTML and plain text
  # representations along with attachments if available.
  class CertificateMailer < ActionMailer::Base
    def certificate_to(mailed_certificate)
      if mailed_certificate.attachment?
        name = mailed_certificate.basename
        attachments[name] = mailed_certificate.certificate
      end

      mail(header_data(mailed_certificate)) do |format|
        format.html { render html: mailed_certificate.html.html_safe }
        format.text { render plain: mailed_certificate.text }
      end
    end

    private

    def header_data(mailed_certificate)
      {
        to: mailed_certificate.recipient,
        from: mailed_certificate.sender,
        bcc: 'inscricoes@agilebrazil.com',
        subject: mailed_certificate.subject
      }
    end
  end
end
