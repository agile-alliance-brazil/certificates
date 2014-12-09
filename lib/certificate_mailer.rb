#encoding: UTF-8
require 'action_mailer'

class CertificateMailer < ActionMailer::Base
  def certificate_to(sender)
    recipients(sender.recipient)
    from(sender.sender)
    subject(sender.subject)
    body(sender.message)
    attachment( :content_type => sender.content_type,
                :body         => sender.certificate,
                :filename     => sender.filename) if sender.has_attachment?
  end
  def self.dry_run!
    class_eval do
      def CertificateMailer.deliver_certificate_to(sender)
        puts "Eu mandaria um email de '#{sender.sender}' para '#{sender.recipient}' com assunto '#{sender.subject}'."
        puts "O corpo seria:"
        puts sender.message
        puts "O email teria um arquivo anexo com tipo #{sender.content_type} com nome de arquivo #{sender.filename}" if sender.has_attachment?
      end
    end
  end
end
