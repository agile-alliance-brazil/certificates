#encoding: UTF-8
class ConfigurationError < StandardError
  def initialize(message)
    super(message)
  end
end
