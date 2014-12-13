#encoding: UTF-8
require_relative './models/certificate_model.rb'
require_relative './converters/inkscape_converter.rb'
require_relative './models/certificate_filename_decorator.rb'
require_relative './models/pdf_path_generator.rb'
require_relative './models/certificate.rb'

class CertificateGenerator
  def initialize(configuration, svg)
    @model = CertificateModel.new(svg)
    @converter = InkscapeConverter.new(configuration.inkscape_path)

    decorator = CertificateFilenameDecorator.new(configuration.certificate['event_short_name'])
    @path_generator = PDFPathGenerator.new(configuration.certificates_folder_path, decorator)
  end
  def generate_certificate_for(attendee)
    attendee_svg = @model.svg_for(attendee)
    pdf = @converter.convert_to_pdf(attendee_svg)
    Certificate.new(attendee, pdf, @path_generator)
  end
end
