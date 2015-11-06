#encoding: UTF-8
class CertificateModel
  def initialize(svg)
    @svg_content = svg
  end
  def svg_for(attendee)
    @svg_content.gsub(/&lt;nome_do_participante&gt;/, attendee.name.upcase)
  end
end
