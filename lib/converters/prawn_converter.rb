#encoding: UTF-8
require 'prawn-svg'

class PrawnConverter
  def initialize(font_paths = [])
    @font_paths = font_paths
  end

  def convert_to_pdf(svg_data)
    print_flow_warning if svg_data.match(/flowRoot/)
    pdf_file = Tempfile.new('temporary.pdf')
    font_families = fonts_for(svg_data)
    Prawn::Document.generate(pdf_file.path, margin: [0,0,0,0], page_size: [width(svg_data), height(svg_data)]) do |prawn|
      prawn.font_families.update(font_families)
      prawn.svg svg_data, at: [0, prawn.bounds.top]
    end
    pdf = pdf_file.read
    pdf_file.unlink
    pdf
  end

  private

  def print_flow_warning
    puts "Your SVG model contains flowRoot elements which are not SVG 1.1 compatible."
    puts "Those elements won't be rendered and they usually are used for text."
    puts "If you generated it with Inkscape, please edit your SVG and ensure all text elements are converted to text tags by using the 'Text->Convert to Text' menu."
  end

  def fonts_for(svg)
    fonts_needed = svg.scan(/font-family:['"]?([^;'"]*)['"]?;/).flatten.uniq
    fonts_needed.inject({}) do |result, family|
      available_family_fonts = @font_paths.select{|p| p.match(/#{family}/)}
      result[family] = available_family_fonts.inject({}) do |m, font|
        if font.match(/#{family}-([^\.-]+)/)
          m.merge($1.to_sym => File.expand_path(font))
        else
          m
        end
      end
      result
    end
  end

  def width(svg)
    svg_property(svg, 'width')
  end

  def height(svg)
    svg_property(svg, 'height')
  end

  def svg_property(svg, property)
    if svg.match(/<svg[^>]*#{property}\s*=\s*['"](\d+)/)
      $1.to_i
    else
      0
    end
  end
end
