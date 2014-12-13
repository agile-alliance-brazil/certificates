#encoding: UTF-8
class PDFPathGenerator
  def initialize(output_folder, decorator)
    @folder = output_folder
    @decorator = decorator
  end
  def path_for(attendee)
    File.expand_path(basename_for(attendee), @folder)
  end
  def basename_for(attendee)
    "#{@decorator.decorate(attendee.name.gsub(/\s/,""))}.pdf"
  end
end
