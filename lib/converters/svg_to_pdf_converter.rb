#encoding: UTF-8
class SVGToPDFConverter
  def initialize(inkscape_path)
    @inkscape_path = inkscape_path
  end
  def convert(svg)
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
