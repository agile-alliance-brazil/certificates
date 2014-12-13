#encoding: UTF-8
class Certificate
  def initialize(attendee, pdf, path_generator)
    @attendee = attendee
    @pdf = pdf
    @path_generator = path_generator
  end
  def has_attachment?
    !@pdf.nil?
  end
  def pdf
    @pdf
  end
  def filename
    @path_generator.basename_for(@attendee)
  end
end
