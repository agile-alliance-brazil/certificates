# encoding:UTF-8

# Certifier VERSION holder
module Certifier
  def self.version
    VERSION::STRING
  end

  module VERSION
    MAJOR = 0
    MINOR = 2
    TINY = 0
    PRE = 'beta'.freeze
    STRING = [MAJOR, MINOR, TINY, PRE].join('.')
  end
end
