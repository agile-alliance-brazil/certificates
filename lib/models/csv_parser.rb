#encoding: UTF-8
require 'csv'
require 'forwardable'

class CSVParser
  extend Forwardable
  def_delegators :@csv, :map, :select

  def initialize(content, has_headers = true)
    @csv = CSV::parse(content)
    @headers = @csv.shift if has_headers
  end

  def to_attributes
    raise 'No headers set' unless @headers

    @csv.map do |row|
      Hash[@headers.map.with_index{|h, idx| [h, row[idx]]}]
    end
  end
end
