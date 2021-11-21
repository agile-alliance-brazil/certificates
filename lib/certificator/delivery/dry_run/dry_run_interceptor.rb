# frozen_string_literal: true

# A mailer interceptor to avoid from actually sending
# the email but rather just log whatever would have happened
class DryRunInterceptor
  def initialize(output = $stdout)
    @output = output
  end

  def delivering_email(message)
    @output.puts build_header(message)
    @output.puts attachment_data(message) if message.has_attachments?
    @output.puts build_body(message)

    message.perform_deliveries = false
  end

  private

  def build_header(message)
    "Eu mandaria um email de '#{message.from.join(', ')}' para \
'#{message.to.join(', ')}' com assunto '#{message.subject}'."
  end

  def build_body(message)
    "O corpo seria:
#{message.text_part}
O html do corpo seria:
#{message.html_part}"
  end

  def attachment_data(message)
    @output.puts "O email teria #{message.attachments.size} arquivo(s) \
anexo(s):"
    attachment_descriptions = message.attachments.map do |attachment|
      "Arquivo '#{attachment.filename}' com tipo #{attachment.content_type}"
    end
    @output.puts attachment_descriptions.join("\n")
  end
end
