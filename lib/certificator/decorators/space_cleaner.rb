# frozen_string_literal: true

module Certificator
  module Decorators
    # Removes spaces from text
    class SpaceCleaner
      def decorate(text)
        text.gsub(/\s/, '')
      end
    end
  end
end
