# encoding:UTF-8
require 'certificator/models/certificate_model'
require 'certificator/converters/inkscape_converter'
require 'certificator/converters/prawn_converter'
require 'certificator/cache_strategy'
require 'certificator/decorators/event_pdf_certificate'
require 'certificator/models/certificate'

# A generator for certificates
# Ties up together a bunch of things to generate a certificate per attendee
class CertificateGenerator
  def initialize(svg, inkscape, cache_path, filename_pattern, font_paths)
    @model = CertificateModel.new(svg)
    @converter = converter_for(inkscape, font_paths)
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

  private

  def converter_for(inkscape, font_paths)
    if inkscape
      InkscapeConverter.new(inkscape)
    else
      PrawnConverter.new(font_paths)
    end
  end
end