#encoding: UTF-8
module Decorators
  class ReplaceText
    def initialize(pattern)
      @pattern = pattern
    end

    def decorate(attributes)
      attributes.inject(@pattern) do |result, (attribute, value)|
        result.gsub(/#{attribute}/, value.to_s)
      end
    end
  end
end
