#encoding: UTF-8
class DryRunInterceptor
  def initialize(output = STDOUT)
    @output = output
  end
  def delivering_email(message)
    @output.puts "Eu mandaria um email de '#{message.from.join(', ')}' para '#{message.to.join(', ')}' com assunto '#{message.subject}'."
    @output.puts attachment_data(message) if message.has_attachments?
    @output.puts "O corpo seria:"
    @output.puts message.text_part

    message.perform_deliveries = false
  end
  private
  def attachment_data(message)
    @output.puts "O email teria #{message.attachments.size} arquivo(s) anexo(s):"
    attachment_descriptions = message.attachments.map do |attachment|
      "Arquivo '#{attachment.filename}' com tipo #{attachment.content_type}"
    end
    @output.puts attachment_descriptions.join("\n")
  end
end
