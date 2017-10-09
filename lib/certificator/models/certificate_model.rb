# encoding:UTF-8

module Certificator
  # Generates SVG certificates based on a provided model
  class CertificateModel
    def initialize(svg)
      @svg_content = svg
    end

    def svg_for(attendee)
      attendee.attributes.inject(@svg_content) do |result, (attribute, value)|
        result.gsub(/&lt;#{attribute}&gt;/, value.to_s)
      end
    end
  end
end
