#encoding: UTF-8
require_relative './space_cleaner.rb'
require_relative './prepend_text.rb'
require_relative './replace_text.rb'
require_relative './append_text.rb'
require_relative './multi.rb'

module Decorators
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
