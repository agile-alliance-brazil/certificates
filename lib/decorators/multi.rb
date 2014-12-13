#encoding: UTF-8
module Decorators
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
