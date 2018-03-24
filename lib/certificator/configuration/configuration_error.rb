# frozen_string_literal: true

# Represents a configuration error
class ConfigurationError < StandardError
  def initialize(message)
    super(message)
  end
end
