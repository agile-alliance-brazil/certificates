#encoding: UTF-8
require_relative '../../spec_helper.rb'

describe Decorators::AppendText do
  subject{ Decorators::AppendText.new('-appendix') }
  it 'should decorate text appending parameter' do
    expect(subject.decorate('file')).to eq('file-appendix')
  end
end
