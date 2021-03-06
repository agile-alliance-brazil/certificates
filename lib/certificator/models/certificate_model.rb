# frozen_string_literal: true

module Certificator
  # Generates SVG certificates based on a provided model
  class CertificateModel
    def initialize(svg)
      @svg_content = svg
    end

    def svg_for(attendee)
      attendee.attributes.inject(@svg_content) do |result, (attribute, value)|
        result.gsub(
          /&lt;#{attribute}&gt;/,
          value.to_s
            .gsub(/&(?!amp;)/, '&amp;')
            .gsub(/</, '&lt;')
            .gsub(/>/, '&gt;')
        )
      end
    end
  end
end
