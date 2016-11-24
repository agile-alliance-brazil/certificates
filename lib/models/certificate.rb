#encoding: UTF-8
class Certificate
  def initialize(attendee, pdf, name_decorator)
    @attendee = attendee
    @pdf = pdf
    @name_decorator = name_decorator
  end

  def has_attachment?
    !@pdf.nil?
  end

  def pdf
    @pdf
  end

  def filename
    @name_decorator.decorate(@attendee.attributes)
  end
end
