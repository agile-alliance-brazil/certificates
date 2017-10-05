# encoding:UTF-8

# Represents a certificate for a given attendee
class Certificator::Certificate
  attr_reader :pdf

  def initialize(attendee, pdf, name_decorator)
    @attendee = attendee
    @pdf = pdf
    @name_decorator = name_decorator
  end

  def attachment?
    !@pdf.nil?
  end

  def filename
    @name_decorator.decorate(@attendee.attributes)
  end
end
