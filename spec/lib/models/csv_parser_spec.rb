#encoding: UTF-8
require_relative '../../spec_helper.rb'

describe CSVParser do
  it 'should ignore first row if header is true' do
    parser = CSVParser.new("data,inline\none,two\n", true)
    expect(parser.select{|r| true}.size).to eq(1)
  end
  it 'should not ignore first row if header is false' do
    parser = CSVParser.new("data,inline\none,two\n", false)
    expect(parser.select{|r| true}.size).to eq(2)
  end
end
