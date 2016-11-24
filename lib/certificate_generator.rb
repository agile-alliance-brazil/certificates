#encoding: UTF-8
require_relative './models/certificate_model.rb'
require_relative './converters/inkscape_converter.rb'
require_relative './converters/prawn_converter.rb'
require_relative './cache_strategy.rb'
require_relative './decorators/event_pdf_certificate.rb'
require_relative './models/certificate.rb'

class CertificateGenerator
  def initialize(svg, inkscape, cache_path, filename_pattern)
    @model = CertificateModel.new(svg)
    @converter = inkscape ? InkscapeConverter.new(inkscape) : PrawnConverter.new
    @cache = CacheStrategy.build_from(cache_path)

    @name_decorator = Decorators::EventPdfCertificate.new(filename_pattern)
  end
  def generate_certificate_for(attendee)
    attendee_svg = @model.svg_for(attendee)
    pdf = @converter.convert_to_pdf(attendee_svg)
    certificate = Certificate.new(attendee, pdf, @name_decorator)
    @cache.cache(certificate)
    certificate
  end
end
