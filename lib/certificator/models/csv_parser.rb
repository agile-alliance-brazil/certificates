require 'csv'
require 'forwardable'

module Certificator
  # Handles parsing CSV.
  # Transforms each row in an attribute map where the keys are
  # the CSV header names and the values are the entries in each row
  class CSVParser
    extend Forwardable
    def_delegators :@csv, :map, :select

    def initialize(content, has_headers = true)
      @csv = CSV.parse(content)
      @headers = @csv.shift if has_headers
    end

    def to_attributes
      raise 'No headers set' unless @headers

      @csv.map do |row|
        attribute_pairs = @headers.map.with_index do |h, idx|
          [h, row[idx]]
        end
        Hash[attribute_pairs]
      end
    end
  end
end
