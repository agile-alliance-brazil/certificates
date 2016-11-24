#encoding: UTF-8
module Decorators
  class PrependText
    def initialize(prepend)
      @prepend = prepend
    end

    def decorate(text)
      @prepend + text
    end
  end
end
