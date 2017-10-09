# encoding:UTF-8
require 'certificator/models/certificate_model'
require 'certificator/converters/inkscape_converter'
require 'certificator/converters/prawn_converter'
require 'certificator/cache_strategy'
require 'certificator/decorators/event_pdf_certificate'
require 'certificator/models/certificate'

module Certificator
  # A generator for certificates
  # Ties up together a bunch of things to generate a certificate per attendee
  class Generator
    def initialize(svg, inkscape, cache_path, filename_pattern, font_paths)
      @model = Certificator::CertificateModel.new(svg)
      @converter = converter_for(inkscape, font_paths)
      @cache = Certificator::CacheStrategy.build_from(cache_path)

      @name_decorator = Certificator::Decorators::EventPdfCertificate.new(
        filename_pattern
      )
    end

    def generate_certificate_for(attendee)
      attendee_svg = @model.svg_for(attendee)
      pdf = @converter.convert_to_pdf(attendee_svg)
      certificate = Certificator::Certificate.new(
        attendee,
        pdf,
        @name_decorator
      )
      @cache.cache(certificate)
      certificate
    end

    private

    def converter_for(inkscape, font_paths)
      if inkscape
        Certificator::InkscapeConverter.new(inkscape)
      else
        Certificator::PrawnConverter.new(font_paths)
      end
    end
  end
end
