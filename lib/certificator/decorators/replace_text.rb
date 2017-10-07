# encoding:UTF-8
module Certificator
  module Decorators
    # Replaces chuncks of text in the pattern with values of
    # attributes named the same way
    class ReplaceText
      def initialize(pattern)
        @pattern = pattern
      end

      def decorate(attributes)
        attributes.inject(@pattern) do |result, (attribute, value)|
          result.gsub(/(?<!\w)#{attribute}(?!\w)/, value.to_s)
        end
      end
    end
  end
end
