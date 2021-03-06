# frozen_string_literal: true

module Certificator
  module Decorators
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
end
