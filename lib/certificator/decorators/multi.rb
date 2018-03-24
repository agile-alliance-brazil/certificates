# frozen_string_literal: true

module Certificator
  module Decorators
    # Represents multiple decorators
    # Chains them and sends the result of the first to
    # the second one and so long
    class Multi
      def initialize(*args)
        @decorators = args.flatten.compact
      end

      def decorate(text)
        @decorators.inject(text) do |result, decorator|
          decorator.decorate(result)
        end
      end
    end
  end
end
