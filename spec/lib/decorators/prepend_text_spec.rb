#encoding: UTF-8
require_relative '../../spec_helper.rb'

describe Decorators::PrependText do
  subject{ Decorators::PrependText.new('suffix-') }
  it 'should decorate text prepending parameter' do
    expect(subject.decorate('file')).to eq('suffix-file')
  end
end
