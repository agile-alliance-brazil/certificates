#encoding: UTF-8
require 'csv'
require 'forwardable'

class CSVParser
  extend Forwardable
  def_delegators :@csv, :map, :select

  def initialize(path, has_headers = true)
    @csv = CSV::parse(File.open(path, 'r') {|f| f.read })
    @csv.shift if has_headers
  end
end
