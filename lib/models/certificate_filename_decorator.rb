#encoding: UTF-8
class CertificateFilenameDecorator
  def initialize(event_short_name)
    @short_name = event_short_name
  end
  def decorate(filename)
    name = "Certificado-"
    name += "#{@short_name}-" if @short_name
    name += filename
    name
  end
end
