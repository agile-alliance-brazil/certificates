#encoding: UTF-8
require_relative './space_cleaner.rb'
require_relative './prepend_text.rb'
require_relative './append_text.rb'
require_relative './multi.rb'

module Decorators
  class EventPdfCertificate
    def initialize(event_short_name = nil)
      decorators = [SpaceCleaner.new]
      decorators << PrependText.new("#{event_short_name}-") if event_short_name
      decorators << PrependText.new('Certificado-')
      decorators << AppendText.new('.pdf')
      @decorator = Multi.new(decorators)
    end
    def decorate(text)
      @decorator.decorate(text)
    end
  end
end
