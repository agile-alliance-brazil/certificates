# frozen_string_literal: true

module Certificator
  # Represents an attendee coming from the CSV
  # It responds to methods named after each column
  # of the CSV provided.
  class Attendee
    attr_reader :attributes

    def initialize(attributes)
      stringified_keys = attributes.map { |k, v| [k.to_s, v] }
      @attributes = Hash[stringified_keys]
    end

    def respond_to_missing?(method, _include_private = false)
      @attributes.key?(method.to_s)
    end

    def method_missing(method, *args, &block)
      if respond_to_missing?(method)
        @attributes[method.to_s]
      else
        super
      end
    end
  end
end
