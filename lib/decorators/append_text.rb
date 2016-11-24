#encoding: UTF-8
module Decorators
  class AppendText
    def initialize(appendix)
      @appendix = appendix
    end

    def decorate(text)
      text + @appendix
    end
  end
end
