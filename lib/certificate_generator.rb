#encoding: UTF-8
require_relative './models/certificate_model.rb'
require_relative './converters/inkscape_converter.rb'
require_relative './decorators/event_pdf_certificate.rb'
require_relative './cache_strategy.rb'
require_relative './models/certificate.rb'

class CertificateGenerator
  def initialize(configuration, svg)
    @model = CertificateModel.new(svg)
    @converter = InkscapeConverter.new(configuration.inkscape_path)
    @cache = CacheStrategy.build_from(configuration)

    event_name = configuration.certificate['event_short_name']
    @name_decorator = Decorators::EventPdfCertificate.new(event_name)
  end
  def generate_certificate_for(attendee)
    attendee_svg = @model.svg_for(attendee)
    pdf = @converter.convert_to_pdf(attendee_svg)
    certificate = Certificate.new(attendee, pdf, @name_decorator)
    @cache.cache(certificate)
    certificate
  end
end
