#encoding: UTF-8
require_relative '../../spec_helper.rb'

describe CSVParser do
  let(:data) { "data,inline\none,two\nthree,four\n" }

  context 'without header' do
    subject(:parser) {  CSVParser.new(data, false) }

    it 'should not ignore first row' do
      expect(parser.select{|r| true}.size).to eq(3)
    end

    it 'should raise exception if trying to get attributes' do
      expect{parser.to_attributes}.to raise_error('No headers set')
    end
  end

  context 'with header' do
    subject(:parser) {  CSVParser.new(data, true) }

    it 'should ignore first row' do
      expect(parser.select{|r| true}.size).to eq(2)
    end

    it 'should generate attributes with keys from header and values from rows' do
      expected_attributes = [
        {'data' => 'one', 'inline' => 'two'},
        {'data' => 'three', 'inline' => 'four'}
      ]

      expect(parser.to_attributes).to eq(expected_attributes)
    end
  end
end
