# encoding:UTF-8

module Certificator
  # Represents a certificate for a given attendee
  class Certificate
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
end
