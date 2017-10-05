# encoding:UTF-8

# Uses inkscape (if available) to generate PDF based on an SVG
class Certificator::InkscapeConverter
  def initialize(inkscape_path)
    @inkscape_path = inkscape_path
  end

  def convert_to_pdf(svg)
    svg_file = Tempfile.new('temporary.svg')
    svg_file.write(svg)
    svg_file.close
    pdf_file = Tempfile.new('temporary.pdf')
    system("#{@inkscape_path} -T -f #{svg_file.path} -A #{pdf_file.path}")
    svg_file.unlink
    pdf = pdf_file.read
    pdf_file.unlink
    pdf
  end
end
