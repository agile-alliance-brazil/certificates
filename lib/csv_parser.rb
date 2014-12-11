#encoding: UTF-8
require 'csv'
require 'forwardable'

class CSVParser
  extend Forwardable
  def_delegators :@csv, :map, :select, :reject

  def initialize(content, has_headers = true)
    @csv = CSV::parse(content)
    @csv.shift if has_headers
  end
end
