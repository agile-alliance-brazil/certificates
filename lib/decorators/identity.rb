# encoding:UTF-8
module Decorators
  # The identity decorator. Returns what is given to it
  class Identity
    def decorate(text)
      text
    end
  end
end
