# encoding:UTF-8

# Certificador module encapsulates all of this gem's code
module Certificator
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
