# frozen_string_literal: true

require 'prawn-svg'

module Certificator
  # Converts an SVG to PDF using the Prawn library
  class PrawnConverter
    def initialize(font_paths = [])
      @font_paths = font_paths
    end

    def convert_to_pdf(svg_data)
      print_flow_warning if svg_data =~ /flowRoot/

      pdf_file = Tempfile.new('temporary.pdf')
      generate_pdf(svg_data, pdf_file)

      pdf = pdf_file.read
      pdf_file.unlink
      pdf
    end

    private

    def print_flow_warning
      puts <<-FLOW_WARNING
  Your SVG model contains flowRoot elements which are not SVG 1.1
  compatible.\nThose elements won't be rendered and they usually are used for
  text.\nIf you generated it with Inkscape, please edit your SVG and ensure all
  text elements are converted to text tags by using the 'Text->Convert to Text'
  menu.
  FLOW_WARNING
    end

    def generate_pdf(svg_data, pdf_file)
      options = {
        margin: [0, 0, 0, 0],
        page_size: [width(svg_data), height(svg_data)]
      }
      Prawn::Document.generate(pdf_file.path, options) do |prawn|
        prawn.font_families.update(fonts_for(svg_data))
        prawn.svg svg_data, at: [0, prawn.bounds.top]
      end
    end

    def fonts_for(svg)
      fonts_needed = svg.scan(/font-family:['"]?([^;'"]*)['"]?;/).flatten.uniq
      fonts_needed.each_with_object({}) do |family, result|
        result[family] = build_family_map(family)
        result
      end
    end

    def build_family_map(family)
      available_family_fonts = @font_paths.select { |p| p.match(/#{family}/) }
      available_family_fonts.inject({}) do |m, font|
        match = font.match(/#{family}-([^\.-]+)/)
        if match
          m.merge(match[1].to_sym => File.expand_path(font))
        else
          m
        end
      end
    end

    def width(svg)
      svg_property(svg, 'width')
    end

    def height(svg)
      svg_property(svg, 'height')
    end

    def svg_property(svg, property)
      match = svg.match(/<svg[^>]*#{property}\s*=\s*['"](\d+)/)
      if match
        match[1].to_i
      else
        0
      end
    end
  end
end
