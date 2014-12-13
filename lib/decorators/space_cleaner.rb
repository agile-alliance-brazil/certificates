#encoding: UTF-8
module Decorators
  class SpaceCleaner
    def decorate(text)
      text.gsub(/\s/,'')
    end
  end
end
