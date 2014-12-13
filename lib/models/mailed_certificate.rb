#encoding: UTF-8
class MailedCertificate
  def initialize(sender, subject, base_body, attendee, certificate)
    @sender = sender
    @subject = subject
    @base_body = base_body
    @attendee = attendee
    @certificate = certificate
  end
  def has_attachment?
    @certificate.has_attachment?
  end
  def basename
    @certificate.filename
  end
  def certificate
    @certificate.pdf
  end
  def recipient
    @attendee.email
  end
  def sender
    @sender
  end
  def subject
    @subject
  end
  def html
    ''
  end
  def text
    "Caro(a) #{@attendee.name},\n" + @base_body
  end
end
