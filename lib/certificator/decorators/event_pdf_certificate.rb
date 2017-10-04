# encoding:UTF-8
require 'certificator/decorators/space_cleaner'
require 'certificator/decorators/prepend_text'
require 'certificator/decorators/replace_text'
require 'certificator/decorators/append_text'
require 'certificator/decorators/multi'

module Decorators
  # The main decorator for PdfCertificate filenames
  # Takes attributes and returns text
  class EventPdfCertificate
    def initialize(pattern = nil)
      decorators = []
      decorators << ReplaceText.new(pattern || 'id')
      decorators << SpaceCleaner.new
      decorators << AppendText.new('.pdf')
      @decorator = Multi.new(decorators)
    end

    def decorate(attributes)
      @decorator.decorate(attributes)
    end
  end
end
