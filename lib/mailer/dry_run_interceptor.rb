#encoding: UTF-8
class DryRunInterceptor
  def self.delivering_email(message)
    puts "Eu mandaria um email de '#{message.from.join(', ')}' para '#{message.to.join(', ')}' com assunto '#{message.subject}'."
    puts attachment_data(message) if message.has_attachments?
    puts "O corpo seria:"
    puts message.text_part

    message.perform_deliveries = false
  end
  private
  def self.attachment_data(message)
    puts "O email teria #{message.attachments.size} arquivo(s) anexo(s):"
    attachment_descriptions = message.attachments.map do |attachment|
      "Arquivo '#{attachment.filename}' com tipo #{attachment.content_type}"
    end
    puts attachment_descriptions.join("\n")
  end
end
