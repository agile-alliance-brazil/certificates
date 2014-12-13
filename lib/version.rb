#encoding: UTF-8
module Certifier
  def self.version
    VERSION::STRING
  end
  module VERSION
    MAJOR = 1
    MINOR = 0
    TINY = 0
    PRE = "alpha"
    STRING = [MAJOR, MINOR, TINY, PRE].compact.join(".")
  end
end