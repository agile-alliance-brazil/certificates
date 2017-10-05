# encoding:UTF-8
module Certificator::Decorators
  # Prepends a text before another text
  class PrependText
    def initialize(prepend)
      @prepend = prepend
    end

    def decorate(text)
      @prepend + text
    end
  end
end
