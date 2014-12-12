#encoding: UTF-8
class BulkSenderWorker
  PROCESSING_INTERVAL = 5
  def initialize(certificate_sender, options = {})
    @errors = []
    @certificate_sender = certificate_sender
    @options = options
  end
  def perform(attendees)
    attendees.each do |attendee|
      begin
        @certificate_sender.send_certificate_to(attendee)
        sleep(PROCESSING_INTERVAL)
      rescue Exception => e
        STDERR.puts "Erro ao enviar certificado para \"#{attendee.name}\" <#{attendee.email}>."
        STDERR.puts "Exceção: #{$!}"
        STDERR.puts e.backtrace
        @errors << attendee
      end
    end
  end
  def error_messages
    unless @errors.empty?
      STDERR.puts "Falha ao enviar certificado para as seguintes pessoas:"
      STDERR.puts "Nome,Email"
      @errors.each do |attendee|
        STDERR.puts %Q{"#{attendee.name}","#{attendee.email}"}
      end
    end
  end
end