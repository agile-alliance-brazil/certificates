module Certificator
  module Decorators
    # Appends a given text at the end of any given text
    class AppendText
      def initialize(appendix)
        @appendix = appendix
      end

      def decorate(text)
        text + @appendix
      end
    end
  end
end
