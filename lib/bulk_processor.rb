#encoding: UTF-8
class BulkProcessor
  PROCESSING_INTERVAL = 5
  def initialize(certificate_sender, options = {})
    @errors = []
    @certificate_sender = certificate_sender
    @options = options
  end
  def process(attendees)
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
  def failed_attendees
    @errors
  end
end