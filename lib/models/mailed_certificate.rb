#encoding: UTF-8
require 'erb'
require 'ostruct'
require 'redcarpet'

class MailedCertificate
  def initialize(sender, base_body, attendee, certificate)
    @sender = sender
    @base_body = base_body
    @attendee = attendee
    @certificate = certificate
    @html_renderer = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true)
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
    erbd_body.split("\n")[0]
  end
  def html
    @html_renderer.render(erbd_body)
  end
  def text
    erbd_body
  end
  private
  def erbd_body
    namespace = OpenStruct.new(attendee: @attendee)
    ERB.new(@base_body).result(namespace.instance_eval{ binding })
  end
end
