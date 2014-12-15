#encoding: UTF-8
require 'prawn-svg'

class PrawnConverter
  def convert_to_pdf(svg_data)
    print_flow_warning if svg_data.match(/flowRoot/)
    pdf_file = Tempfile.new('temporary.pdf')
    Prawn::Document.generate(pdf_file.path, margin: [0,0,0,0]) do |prawn|
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
end
